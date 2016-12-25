// Testing file I/O
// Pass/fail:

// Include()
// Upload()
// Telemetry_log()
// Telemetry_newline()

copypath("0:std/stdio.ks", "").
run stdio.ks.

clearscreen.
print "Testing file i/o".
wait 5.

include("Science.ks").
telemetry_log("First, Second, Third, Fourth, Fifth").
telemetry_newline().
upload("telemetry.csv").
