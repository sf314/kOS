// Log stuff to output file!!!

// Telemetry
// Uses global variable 'telemetry_message'.
set telemetry_message to " ".
function telemetry_log {
	parameter ms.
	set telemetry_message to telemetry_message + ms + ", ".
}

function telemetry_newLine {
    log telemetry_message to "0:telemetry.csv".
    set telemetry_message to " ".
} // Save with upload() command.

set globalVesselStartTime to time:seconds.
function millis {
    // Interacts with the global vessel load time.
    return time:seconds - globalVesselStartTime.
}



until periapsis > 70000 {
    // Log telem
    telemetry_log(round(millis(), 2)). // Time
    telemetry_log(altitude).
    set angle to 90 - vang(up:vector, ship:facing:vector).
    telemetry_log(angle).
    telemetry_log(apoapsis).
    telemetry_newLine().
    wait 1.
}
