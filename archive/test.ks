// Test file for linear - fashion launch sequence
// vars
set mysteer to up.
lock steering to mysteer.
function gravAngle {
    parameter alt.
    local result is 360/7 - 9 * alt / 14000.
    clearscreen.
    print "GravAngle".
    print result.
    return result.
}

// initialize
clearscreen.
print "Running test...".

// countdown
from {local t is 10.} until t <= 0 step {set t to t - 1.} do {
    print t.
    wait 1.
}


// launch to 10k
print "launching @5deg".
lock throttle to 1.0.
set mysteer to heading(90,85).

// **** staging logic
lock shouldStage to stage:liquidfuel < 0.1 and throttle > 0.1.
when shouldStage then {
    print "auto-staging. Line 31.".
    stage.
    preserve.
}
wait until ship:altitude > 10000.

// perform gravity turn at 10k
print "Performing gravity turn".
lock someAngle to gravAngle(altitude).
lock mysteer to heading(90,someAngle).
wait until ship:orbit:apoapsis > 75000.
lock throttle to 0.
lock mysteer to prograde.
print "Suborbital burn complete. Steering prograde".

wait until ship:altitude > 70000.
print "waiting until apoapsis...".



// perform circularization
print "ready to perform cicrularization".
until ship:orbit:periapsis > 75000 {
    clearscreen.
    print eta:apoapsis.
    print "within until peri > 75k".

    if eta:apoapsis < 30 {
        print"if".
        set add to throttle + 0.01.
        set t to min(1, add).
        lock throttle to t.
    } else {
        print "else".

        if periapsis > 0 {
            print "almost there".
            lock throttle to 1.
        } else {
            print "other else".
            set sub to throttle - 0.01.
            set t to max(0, sub).
            lock throttle to t.
        }

    }


    // stagin logic
    if stage:liquidfuel < 0.1 {
        stage.
        print "staging".
    }

    wait 0.001.

}
print "Successful orbital insertion".
lock throttle to 0.
sas on.
unlock all.








wait until abort. // call for landing.

clearscreen.
// prep for landing
lock mysteer to retrograde.
wait 10.

// deorbit burn
print "deorbiting".
lock throttle to 1.
wait until periapsis < 25000.
lock throttle to 0.
wait 10.
stage. // stage away last fuel tank     // gets rid of fuel but also makes clicky noises.
print "fionished deorbiting".

// deploy drogue chutes
wait  until altitude < 5000.
print "deploying drogue chutes".
stage.

// deploy main chutes
wait until alt:radar < 1000.
print "deploying main chutes".
stage.

wait until alt:radar < 10.
print "Landed!".
unlock all.









// ***** alternate staging logic (Deperecated, buggy)
// when shouldStage then { // this is an issue due to the throttle check?
//     print "staging...".
//     stage.
// }
// wait until ship:altitude > 10000.

// // alternate
// until ship:: altitude > 10000 {
//     if maxthrust = 0 and throttle > 0.1 {
//         stage.
//     }
// }
