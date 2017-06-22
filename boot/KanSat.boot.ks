// KanSat Boot File. Copies all contents of KanSat folder to local
// volume. Then runs main.
// Be sure that KanSat has no electricity on startup, so it can't run main.

// Copy files to volume on KanSat
copypath("0:/KanSat/main.ks", "1:/main.ks");
copypath("0:/KanSat/KSLog.ks", "1:/KSLog.ks");
copypath("0:/KanSat/KSComms.ks", "1:/KSComms.ks");
copypath("0:/KanSat/KSAlt.ks", "1:/KSAlt.ks");
copypath("0:/KanSat/KSPitot.ks", "1:/KSPitot.ks");
copypath("0:/KanSat/KSPower.ks", "1:/KSPower.ks");
copypath("0:/KanSat/KSimu.ks", "1:/KSimu.ks");

// Basic include() function
// Be sure that included files are just function files!
function include {
    parameter file.
    runoncepath(file).
}

function notify {
	parameter ms.
	HUDTEXT("kOS: " + ms, 5, 2, 50, white, false).
}

set globalVesselStartTime to time:seconds.
function millis {
    // Interacts with the global vessel load time.
    local timeInSeconds istime:seconds - globalVesselStartTime.
    local timeMillis is round(timeSeconds * 1000). // Test?)
    return timeMillis.
}

function delay {
    // Like ardy delay function (does nothing during delay)
    parameter t.
    local timeToWait is t / 1000.
    wait timeToWait.
}


// Run main.
runpath("main.ks").
