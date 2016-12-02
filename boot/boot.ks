// boot.ks
// ***** Use of boot script:
// Load boot script onto all CPUS
// Will run on startup (or focus)
// If an update file exists in updates directory (titled with craftName.update), load and run it.
// Otherwise, if a boot file exists in updates directory (titled crafName.boot), load and run it.




// Set user throttle to zero
set ship:control:pilotmainthrottle to 0.

// Load specific libs to the onboard computer (requires connection!)
copypath("0:/std/stdio", "").
copypath("0:/std/stdlib", "").
run stdio.
run stdlib.


// *** Add a file to run on boot:
print "Boot script complete. Proceed with operation.".

// Check for new instructions, else boot from custom boot (if exists)
set updateScript to ship:name + ".update".
set archivePathToUpdateScript to "0:updates/" + updateScript.
set craftBootScript to ship:name + ".boot".
set archivePathToBootScript to "0:boot/" + craftBootScript.

if exists(archivePathToUpdateScript) {
    // Check if update exists in Archive (like on subseqent loads)
	copypath(archivePathToUpdateScript, "").
	run updateScript.
} else if exists(archivePathToBootScript) {
    // Check if custom boot script exists in Archive (like on first load)
    copypath(archivePathToBootScript, "").
    run craftBootScript.
}
// Neither a custom boot script nor an update exists.
// Check again after 10s. Create simple boot script for craft to load.

wait 10.
reboot.
