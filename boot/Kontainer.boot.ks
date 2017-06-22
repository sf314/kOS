// Kontainer boot file. Should be overall simpler system.

copypath("0:/Kontainer/main.ks").
copypath("0:/KanSat/KSAlt.ks").
copypath("0:/KanSat/KSPower.ks").
copypath("0:/KanSat/KSComms.ks").


// Basic include() function
// Be sure that included files are just function files!
function include {
    parameter file.
    runpath(file).
}

function notify {
	parameter ms.
	HUDTEXT("kOS: " + ms, 5, 2, 50, white, false).
}

set globalVesselStartTime to time:seconds.
function millis {
    // Interacts with the global vessel load time.
    set timeInSeconds to time:seconds - globalVesselStartTime.
    set timeMillis to round(timeSeconds * 1000).
}


// Run main.
runpath("main.ks").
