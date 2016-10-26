// boot.ks
// Initial boot script. Use to run file on bootup.

// Set user throttle to zero
set ship:control:pilotmainthrottle to 0.

// Load a specific libs to the onboard computer (or not)
copypath("0:/std/stdio", "").
run stdio.

copypath("0:/std/stdlib", "").
run stdlib.

copypath("0:reboot.ks", "").

// copy pidtest from 0.
// run pidtest(300).

// *** Add a file to run on boot:
print "Boot script complete. Proceed with operation.".
