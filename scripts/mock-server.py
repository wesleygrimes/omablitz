#!/usr/bin/env python3
"""Tiny static JSON API for local plugin work. No deps beyond stdlib."""
from __future__ import annotations

import json
import os
import re
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

ROOT = Path(__file__).resolve().parents[1]
FIXTURES = ROOT / "mock" / "fixtures"
HOST = os.environ.get("OMABLITZ_MOCK_HOST", "127.0.0.1")
PORT = int(os.environ.get("OMABLITZ_MOCK_PORT", "8787"))


def load(name: str):
    return json.loads((FIXTURES / name).read_text(encoding="utf-8"))


class Handler(BaseHTTPRequestHandler):
    server_version = "OmablitzMock/0.1"

    def log_message(self, fmt: str, *args) -> None:
        print(f"[{self.log_date_time_string()}] {fmt % args}")

    def _send(self, code: int, body, content_type: str = "application/json") -> None:
        raw = body if isinstance(body, (bytes, bytearray)) else json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(raw)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(raw)

    def do_OPTIONS(self) -> None:  # noqa: N802
        self.send_response(204)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "*")
        self.end_headers()

    def do_GET(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        path = parsed.path.rstrip("/") or "/"
        qs = parse_qs(parsed.query)

        if path == "/health":
            return self._send(200, {"ok": True})

        if path == "/v1/teams":
            teams = load("teams.json")
            q = (qs.get("q") or [""])[0].strip().lower()
            if q:
                teams = [
                    t
                    for t in teams
                    if q in t["name"].lower()
                    or q in t.get("abbr", "").lower()
                    or q in t.get("conference", "").lower()
                ]
            return self._send(200, {"teams": teams})

        if path == "/v1/games/today":
            return self._send(200, load("games-today.json"))

        m = re.fullmatch(r"/v1/games/([^/]+)", path)
        if m:
            game_id = m.group(1)
            detail = load("game-detail.json")
            if detail.get("id") == game_id:
                return self._send(200, detail)
            for game in load("games-today.json")["games"]:
                if game.get("id") == game_id:
                    return self._send(200, game)
            return self._send(404, {"error": "not_found", "id": game_id})

        return self._send(404, {"error": "not_found", "path": path})


def main() -> None:
    if not FIXTURES.is_dir():
        raise SystemExit(f"missing fixtures dir: {FIXTURES}")
    httpd = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"Omablitz mock listening on http://{HOST}:{PORT}")
    print("  GET /health")
    print("  GET /v1/teams?q=")
    print("  GET /v1/games/today")
    print("  GET /v1/games/:id")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nbye")


if __name__ == "__main__":
    main()
