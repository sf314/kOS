// Testing powered descent in kOS
// Theory: (where T is thrust)
// T =    mg (constant velocity)
// T = 0.8mg (descend faster)
// T = 1.2mg (descend slower)
// T = k*mg (custom descent constant)

// ********** INITIALIZE ******************************************************
unlock all.
set ship:control:pilotmainthrottle to 0.
lock steering to R(0,0,-90) + HEADING(90,90).

// ********** CONTROLS ********************************************************
set state to -1.
    set boost to -1.
    set ascending to 0.
    set freefall to 1.
    set testBurn to 2.
    set controlledBurn to 3.
    set landed to 4.
set seekAgression to 0. // Constant of change of thrust
set alt to alt:radar.
set t to 0.
set impactTime to 0.

// ********* FUNCTIONS ********************************************************
function printTelemetry {
    clearscreen.
    print "time = " + round(t / 1000, 3).
    print "alt  = " + round(alt:radar, 3).
    print "tti  = " + round(impactTime, 3).
    print "v    = " + round(verticalspeed, 3).
    print "Mass = " + round(ship:mass / 1000, 3). // kg
    print "maxT = " + round(ship:maxthrust / 1000, 3). // kN, now N
    print "avaT = " + round(ship:availablethrust / 1000, 3). // kN, now N
    print "m*g  = " + round(ship:mass * 9.81, 3).
    print "sAg  = " + round(seekAgression, 3).
    print "st   = " + state.
    print "situ = " + ship:status.
}

function notify {
	parameter ms.
	HUDTEXT("kOS: " + ms, 5, 2, 50, white, false).
}

set globalVesselStartTime to time:seconds.
function millis {
    // Interacts with the global vessel load time.
    return 1000 * (time:seconds - globalVesselStartTime). // milliseconds!
}


// ********* MAIN PROGRAM *****************************************************
until false {
    // Calculate vars
    set alt to alt:radar.
    set t to millis().

    printTelemetry().

    // Switch on state
    if state = boost {
        wait 5.
        lock throttle to 1.
        stage.
        wait 4.
        lock throttle to 0.
        set state to ascending.
    }

    if state = ascending {
        if (verticalspeed < 0) {
            set state to freefall.
        }
    }

    if state = freefall {
        // Calculate when to start burning! (like in hyperloop)
        // initiate burn then switch state.
    }

    if state = testBurn {

    }

    if state = controlledBurn {

    }

    if state = landed {
        unlock all.
        set ship:control:pilotmainthrottle to 0.
    }
}
