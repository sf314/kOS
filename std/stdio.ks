// lib.stdio.ks
// Functions for handling I/O

// *Todo
// Consider changing to a core Flight System standpoint, with kFS runloop
// Add blackbox functions

set globalVesselStartTime to time:seconds.

function notify {
	parameter ms.
	HUDTEXT("kOS: " + ms, 5, 2, 50, white, false).
}


function fwrite {
	parameter ms.
	log "fwrite: " + ms to log.txt.
	// Test if it writes "ms" or an actual log message!
}

function millis {
    // Interacts with the global vessel load time.
    return time:seconds - globalVesselStartTime.
}

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


// Copies to local storage and runs file
// ex. include("Sensors.ks").
// Assumed to be in 0:/
// Only attempts copy if file is not present.
function include {
    parameter file.

    if exists(file) {
        set path to "1:" + file.
        copypath(path, "thing.ks").
        run thing.ks.
        deletepath("thing.ks").
    } else {
        // Get from archive
        set path to "0:" + file.
        print "Retrieving " + file + " from archive.".
        copypath(path, "").

        // Run from local
        set path to "1:" + file.
        copypath(path, "thing.ks").
        run thing.ks.
        deletepath("thing.ks").
    }
}

// Send a file to the archive, in the data folder, specifically
// ex. upload("telemetry.csv").
function upload {
    parameter file.
    set targetpath to "0:data/" + file.
    copypath(file, targetpath).
}
