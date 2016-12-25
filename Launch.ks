// Basic launch script, modelling gravity turn.
// Formula for gravity turn: (where horizontal is 90)
// 21.1343ln(0.00106656(0)) // only works when alt:radar > 1000

copypath("0:std/stdio.ks", "").
run stdio.ks.

function maxTWR {
    set g to body:mu / ((ship:altitude + body:radius)^2).
    return ship:maxthrust / (g * ship:mass). // = maxtwr
    //lock throttle to min(1.3 / maxtwr, 1).
}

function setTWR {
    parameter tgtTWR.
    set throttle to min(tgtTWR, maxTWR()).
}

function angle {
    parameter alt.
    return 90 - 21.1343 * ln(0.00106656 * alt).
}

// Launch in stages, with desired TWR and angle
set state to 0.
until apoapsis > 75000 {
    // Stage 1: straight up, 1000, twr 1.3
    // Stage 2: Curve to 10000
    // Stage 3: All the way
    if alt:radar < 1000 {
        set throttle to setTWR(1.3).
        set steering to up.
        set state to 1.
    } else if alt:radar < 10000 {
        set throttle to setTWR(1.5).
        set steering to heading(90, angle(alt:radar)).
        set state to 2.
    } else {
        set throttle to 1.
        set steering to heading(90, angle(alt:radar)).
        set state to 3.
    }
    wait 0.05.
    clearscreen.
    print "Alt: " + round(alt:radar).
    print "Apo: " + round(apoapsis).
    print "Per: " + round(periapsis).
    print "State " + state.
}

wait until eta:apoapsis < 30.
// Brute force it!
lock steering to heading (90, 0).
lock throttle to 1.
wait until periapsis > 70000.
unlock all.

clearscreen.
print "Done!".
t
