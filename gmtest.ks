
// Guided missile
copypath("0:/std/stdio.ks", "").
//copypath("0:/std/stdlib.ks", "").
run stdio.ks.
//run stdlib.ks.

copypath("0:boot/gmtest.boot.ks", "").

until abs(verticalspeed) > 10 {

}

set startTime to millis().


lock throttle to 1.
set targetDir to Vessel("tgt"):direction.
lock steering to targetDir.


// Find target.

//set target to Vessel("tgt").
// lock steering to target:direction. // Works only if target is set.

until false {

    if (millis() - startTime) < 1 {
        // Keep heading toward init for 3 seconds
    } else {
        // Now actively track
        set targetDir to Vessel("tgt"):direction. // updates direction.
    }

    set Vectordraw TO VECDRAWARGS(v(0,0,0), targetDir:vector:normalized, rgb(1,0.5,0.5),"", 12.0, true ).
    wait 0.001.
}
unlock all.
clearscreen.
