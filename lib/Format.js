.pragma library

// Pure helpers — keep Omarchy/Quickshell out of here so qmltestrunner can load them.

function apiBase() {
    // Prefer an explicit override (mise.dev sets OMABLITZ_API_BASE). Fall back to prod.
    var env = ""
    try {
        if (typeof Quickshell !== "undefined" && Quickshell.env)
            env = Quickshell.env("OMABLITZ_API_BASE") || ""
    } catch (e) {}
    if (env && env.length)
        return env.replace(/\/$/, "")
    return "https://omablitz.grimes.pro"
}

function pulseLabel(game) {
    if (!game)
        return ""
    if (game.status === "live") {
        var a = game.away && game.away.score != null ? game.away.score : 0
        var h = game.home && game.home.score != null ? game.home.score : 0
        return a + "–" + h
    }
    if (game.status === "final")
        return "Final"
    if (!game.kickoff)
        return ""
    var d = new Date(game.kickoff)
    if (isNaN(d.getTime()))
        return ""
    var days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var mins = d.getMinutes()
    var hours = d.getHours()
    var ampm = hours >= 12 ? "PM" : "AM"
    var h12 = hours % 12
    if (h12 === 0)
        h12 = 12
    var mm = mins < 10 ? "0" + mins : "" + mins
    return days[d.getDay()] + " " + h12 + ":" + mm + " " + ampm
}

function scorebugText(game) {
    if (!game || !game.away || !game.home)
        return ""
    if (game.status === "scheduled")
        return pulseLabel(game)
    var a = game.away.score != null ? game.away.score : 0
    var h = game.home.score != null ? game.home.score : 0
    return a + "–" + h
}
