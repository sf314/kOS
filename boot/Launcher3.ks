// Launcher 3 script
// 1.25m 4-ton payload.
// Set abort conditions!
copypath("0:std/stdlib.ks", "").
copypath("0:std/stdio.ks", "").
run stdlib.ks.
run stdio.ks.

set end to false.
set st to 1.
set thr to 0.
lock throttle to thr.

until RCS {}. rcs off.

notify("Starting mission").

until end {
    // ***** Ascent profile
    if st = 1 {
        if altitude < 2000 { // angle?
            lock steering to up.
            set thr to 1.
        } else {
            //set angle to (6750 / 73) - (9 * altitude / 7300).
            set angle to (-90 / 73000) * (altitude) + 90.
            lock steering to heading(90, angle).
            set thr to 1.
        }

        if apoapsis > 75000 { // st change?
            set thr to 0.
            set st to 2.
        }

        if maxthrust < 0.1 { // stage?
            stage.
            wait 0.1.
        }

        if verticalspeed < 0 { // Emergency?
            notify("Emergency detected").
            lock throttle to 0.
            set end to true.
            abort on.
            wait 5.
        }
    }

    // ***** Wait
    if st = 2 {
        set thr to 0.
        lock steering to prograde.

        if eta:apoapsis < 30 { // st change?
            set st to 3.
        }
    }

    // ***** Circularize
    if st = 3 {
        set thr to 1.
        lock steering to heading(90,0).

        if maxthrust < 0.1 { // stage?
            stage.
            wait 0.1.
        }

        if periapsis > 70000 { // st change?
            set thr to 0.
            set end to true.
        }
    }
}

// End of script. Should be in orbit!
unlock all.
if periapsis > 70000 {
    notify("Orbit achieved").
} else {
    notify("Program endd.").
}
