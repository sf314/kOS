// Series of functions to test functionality of functions!
// If anything breaks, you know you need to do some work

function include {
    parameter file.
    runpath(file).
    // Here, all includes will have full path listing, but this is not necessary.
}
print "***** Testing include() function.\nShould put stdlib.ks in local volume:".
include("0:/std/stdlib.ks").
list files.

print "***** Testing notify()".
function notify {
	parameter ms.
	HUDTEXT("kOS: " + ms, 5, 2, 50, white, false).
}
notify("Test notification!").

print "***** Testing millis() and delay()".
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
print "\tCurrent millis() is " + millis().
delay(2000).
print "\tCurrent millis() is " + millis().

copypath("0:/KanSat/KSAlt.ks", "").
runpath("KSAlt.ks").
KSAlt_setGroundHeight(70).
print "***** Testing KSAlt functions:".
print "\tAltitude: " + KSAlt_altitude().
print "\tAlt Radar: " + KSAlt_altitudeRadar().
print "\tTemp: " + KSAlt_temperature().
print "tPress: " + KSAlt_pressure().

print "***** Testing ground transmissions".
include("0:/KanSat/KSComms.ks").
KSComms_addGroundTelemetry("Hello, this is ground telemetry").
KSComms_transmitTelemetry().

print"***** Testing local telemetry logging".
include("0:/KanSat/KSLog.ks").
KSLog_addTelemetry(1).
KSLog_addTelemetry(2).
KSLog_addTelemetry(3).
KSLog_saveTelemetry().
list files.
print("\tShould have listed the log file")

print "***** Testing pitot tube".
include("0:/KanSat/KSPitot.ks").
print "\tVelocity = " + KSPitot_progradeVelocity().

print "***** Testing imu".
include("0:/KanSat/KSimu.ks").
print "\timu accelX = " + KSimu_accelX().
