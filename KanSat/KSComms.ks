// KSComms
// Communication telemetry to the ground (via saving file)

// 'Communicate' by logging to a file on the ground.

// ********** File names ******************************************************
set groundTelemetryFile to "groundTelemetry.csv".
set groundLogFile to "groundLog.csv".
set KSComms_packetCount to 0. // Should be recoverable on restart?

function KSComms_setGroundFilenames {
    parameter tFile.
    parameter lFile.
    set groundTelemetryFile to tFile.
    set groundLogFile to lFile.
}

// ********** Data variables to work with *************************************
set groundTString to "".
set groundLString to "".

// ********** Add data to strings *********************************************
// Packetize ground telemetry before sending
function KSComms_addGroundTelemetry {
    parameter ms.
    set groundTString to groundTString + ms + ", ".
}

function KSComms_addGroundLog {
    parameter ms.
    set groundLString to groundLString + ms + " : ".
}

// ********** Transmit (save to file on disk) *********************************
function KSComms_transmitTelemetry {
    // Test if path variable works
    local path is "0:/KanSat/" + groundTelemetryFile.
    log groundTString to path.
    set KSComms_packetCount to KSComms_packetCount + 1.
}

function KSComms_transmitLog {
    local path is "0:/KanSat/" + groundLogFile.
    log groundLString to path.
}
