// Betta 1 Flight Software
// Betta Program Launch ID: 1
// Objective: Scripted orbital insertion of 3-stage rocket with mock payload
print "Initializing...".

// ********** Load Libraries **************************************************
copypath("0:std/stdio.ks", ""). run stdio.ks.
copypath("0:std/stdlib.ks", ""). run stdlib.ks.
notify("Standard libraries loaded").

// ********** Initialize variables ********************************************
set ship:control:pilotmainthrottle to 0.
set state to 0.
    set launchpad to 0.
    set primaryAscent to 1.
    set coast to 2.
    set circularization to 3.
    set complete to 4.
    
// ********** Calculate gravity angle *****************************************
function gravAngle {
    parameter a. // Altitude
    if a < 5000 {
        return 90.
    } else if (a > 5000) and (a < 50000) {
        return -0.001333333333 * (a - 5000) + 90. 
        // Linear interpolation? = (-60/45000)*(a - 5000) + 90
    } else if (a > 50000) and (a < 70000) {
        return 20.
    }
}

// ********** Main ********************************************
until state = complete {
    // State checks
    if state = launchpad {
        from {set x to 10.} until x = 0 step {set x to x - 1.} do {
            print x.
            wait 1.
        }
        notify("Initiating Ascent sequence").
        set state to primaryAscent.
        
    } else if state = primaryAscent {
        // Throttle control
        if (altitude < 4000) and (verticalspeed > 300) { lock throttle to 0.7. } 
        else { lock throttle to 1. }
        
        // Steering control
        set theta to gravAngle(altitude). 
        lock steering to heading(90, theta). sas off.
        
        // Check staging
        if maxthrust < 0.1 { stage. wait 1. }
        
        // State change condition
        if (apoapsis > 75000) { 
            notify("Moving to Coast phase").
            set state to coast. 
        }
        
    } else if state = coast {
        lock throttle to 0.
        lock steering to heading(90, gravAngle(altitude)). sas off.
        
        // State change condition
        if (eta:apoapsis < 30) {
            notify("Initializing circularization sequence").
            set state to circularization.
        }
    } else if state = circularization {
        lock throttle to 1.
        lock steering to heading(90, 0). sas off.
        
        // Staging
        if maxthrust < 0.1 { stage. wait 1. }
        
        // State change condition
        if (periapsis > 70000) {
            set state to complete.
        }
    } else if state = complete {
        notify("Orbital insertion complete").
        sas on.
        unlock all.
    }
    
    
}