// boot.ks
// ***** Use of boot script:
// Load boot script onto all CPUS
// Will run on startup (or focus)
// If an update file exists in updates directory (titled with craftName.update.ks), load and run it.
// Otherwise, if a boot file exists in updates directory (titled crafName.boot.ks), load and run it.

print "Boot.ks".


// Set user throttle to zero
set ship:control:pilotmainthrottle to 0.
// activate telnet!
set config:telnet to true.

// Load specific libs to the onboard computer (requires connection!)
copypath("0:/std/stdio.ks", "").
copypath("0:/std/stdlib.ks", "").
run stdio.ks.
run stdlib.ks.


// *** Add a file to run on boot:
print "Boot script complete. Proceed with operation.".

// Check for new instructions, else boot from custom boot (if exists)
set updateScript to ship:name + ".update.ks".
set archivePathToUpdateScript to "0:updates/" + updateScript.
set craftBootScript to ship:name + ".boot.ks".
set archivePathToBootScript to "0:boot/" + craftBootScript.

print "Looking for " + updateScript + " at " + archivePathToUpdateScript.
print "Looking for " + craftBootScript + " at " + archivePathToBootScript.

if exists(archivePathToUpdateScript) {
    print "Update script detected".
    // Check if update exists in Archive (like on subseqent loads) (requires rename scheme)
	copypath(archivePathToUpdateScript, "").
    movepath(updateScript, "update.ks").
	run update.ks.
} else if exists(archivePathToBootScript) {
    print "Boot script detected".
    // Check if custom boot script exists in Archive (like on first load)
    copypath(archivePathToBootScript, "").
    //rename craftBootScript to "boot". // Deprecated!
    movepath(craftBootScript, "bootscript.ks").
    print "Current list of files:".
    list files.
    run bootscript.ks.
} else {
    // Neither a custom boot script nor an update exists.
    from {set x to 10.} until x = 0 step {set x to x - 1.} do {
    	print "Boot.ks: " + x.
    	wait 1.
    }
    reboot.
}
