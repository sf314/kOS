// KSLog
// For logging telemetry to a file.

// Can either go to main telemetry file or to log file.
// For ground telemetry, collect data in string and transmit all at once.
// For local telemetry, collect data in string and save all at once.
// In order to transmit, use


// ********** Set telemetry file and log file for craft. **********************
set telemetryFile to "telemFile.csv".
set logFile to "logFile.txt".
set localTelemetryFile to "localTelem.csv".
set localLogFile to "localLog.txt".

function KSLog_setFileNames {
    parameter telPath.
    parameter logPath.
    set telemetryFile to telPath.
    set logFile to logPath.
}

// ********** Data variables to interact with *********************************
// Generally private
set telemetryString to "".
set logString to "".

// ********* Add data to strings **********************************************
function KSLog_addTelemetry {
    parameter val.
    set telemetryString to telemetryString + val + ", ".
}

function KSLog_addLog {
    parameter ms.
    set logString to logString + ms + ", ".
}

// ********** Ccommit data to file ********************************************
function KSLog_saveTelemetry {
    log telemetryString to telemetryFile.
    set telemetryString to "".
}

function KSLog_saveLog {
    log logString to logFile.
    set logString to "".
}
