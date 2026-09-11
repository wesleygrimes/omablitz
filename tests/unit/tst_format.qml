import QtQuick
import QtTest
import "../../lib/Format.js" as Format

TestCase {
  name: "FormatHelpers"

  function test_api_base_default() {
    // No Quickshell env in qmltestrunner → production host.
    compare(Format.apiBase(), "https://omablitz.grimes.pro")
  }

  function test_pulse_live() {
    var game = {
      status: "live",
      away: { score: 10 },
      home: { score: 14 }
    }
    compare(Format.pulseLabel(game), "10–14")
  }

  function test_pulse_final() {
    compare(Format.pulseLabel({ status: "final" }), "Final")
  }

  function test_pulse_empty() {
    compare(Format.pulseLabel(null), "")
    compare(Format.pulseLabel({}), "")
  }

  function test_scorebug_live() {
    var game = {
      status: "live",
      away: { score: 3 },
      home: { score: 7 }
    }
    compare(Format.scorebugText(game), "3–7")
  }
}
