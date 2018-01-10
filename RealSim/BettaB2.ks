// Stephen Flores
// Betta 2 Upper stage payload flight software
// Requirements:
// Get to orbit from 27km altitude
// Approx. deltaV: 2000 m/s (?)
// Betta upper stage: 27km to KEO, single-engine
// Housed in payload fairing. Detach and decouple before igniting engine.
// Target 13.4t total mass including fairing and large docking port.

// v1.0: Basic linear script. Series of loops.

// ***** Functions
function gravAngle {
    parameter a.
    // Linear mapping?
    // 50 degrees from now till 30
    return 50.
}

// ***** State 0: Wait to 30km
    // Release fairing and decoupler
    // Ignite 2nd stage engine (vacuum)
    // 
    lock throttle to 0.
    lock steering to heading(90, 50).
    stage. wait 1. // Fairing
    stage. // Decoupler AND engine
    lock throttle to 1.
    until altitude > 30000 {
        if verticalspeed < 0 {
            print "Emergency: Descending.".
            lock throttle to 0.
            ag0 on. // Emergency sequence
            break. 
        }
    }
    

// ***** State 1: Pitch manoeuvre
    // Calculate gravAngle
    // Pitch to gravAngle
    // Wait until 
    

// ***** State 2: Coast

// ***** State 3: Orbital insertion burn

// ***** State 4: Science mode