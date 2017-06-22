// Hornet T1 bootfile
// Test hover capability of Hornet
// NOTE: Be sure to set the tag of 1st stage engines to Hornet1stStage

// ********** INITIALIZE ******************************************************
unlock all.
set ship:control:pilotmainthrottle to 0.
lock steering to R(0,0,-90) + HEADING(90,90).

// ********** CONTROL VARIABLES ***********************************************
set t to 0.
lock throttle to t.
set state to 0.
    set launchpad to 0.
    set ascending to 1.
    set hovering to 2.
    set descending to 3.
    set landed to 4.

set seekAgression to 0.
lock altr to alt:radar.

// ********** FUNCTIONS *******************************************************
set globalVesselStartTime to time:seconds.
function millis {
    // Interacts with the global vessel load time.
    return 1000 * round(time:seconds - globalVesselStartTime). // milliseconds!
}
// *** PID setup
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
//LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
//LOCK gforce TO accvec:MAG / g.
function totalThrust {
    local sum to 0.
    //list engines in enlist.
    set enlist to ship:partstagged("Hornet1stStage").
    for en in enlist {
        //print "en: " + en:thrust.
            set sum to (sum + en:thrust).
    }
    return sum.
}
lock gforce to totalThrust() / (ship:mass * g).
function printTelemetry {
    clearscreen.
    print "Time    = " + millis().
    print "Situ    = " + ship:status.

    print "Alt     = " + round(altr, 3).
    print "Vel     = " + round(verticalspeed, 3).
    print "Mass    = " + round(ship:mass / 1000, 3). // kg
    print "Thr.M   = " + round(ship:maxthrust / 1000, 3). // kN, now N
    print "Thr.A   = " + round(ship:availablethrust / 1000, 3). // kN, now N
    print "m * g   = " + round(ship:mass * 9.81, 3).
    print "seekAg  = " + round(seekAgression, 3).
    print "State   = " + state.
    print "Situ    = " + ship:status.
    print "Thr.Tot = " + totalThrust().
    print "T       = " + t.
}
// PID should take twr and output thrust
set throttlePID to PIDLOOP(0.01, 0.006, 0.006).
function seekTWR {
    parameter desiredTWR.
    set throttlePID:setpoint to desiredTWR.
    set t to max(min(t + throttlePID:Update(time:seconds, gforce), 1), 0). // only between 0 and 1.
}

function notify {
	parameter ms.
	HUDTEXT("kOS: " + ms, 5, 2, 50, white, false).
}

// ********** Runloop *********************************************************
until false {
    printTelemetry().
    if state = launchpad {
        notify("Starting in 1...").
        wait 1.
        stage.
        set state to ascending.
    }
    if state = ascending {
        // Ascend at rate of 5m/s
        // Climb to 5/ms at 1.2g
        // if verticalspeed < 5 {
        //     seekTWR(1.1).
        // } else {
        //     seekTWR(0.9).
        // }
        // if altr > 50 {
        //     set state to hovering.
        // }
        set t to 1.
        wait 10.
        set t to 0.
        wait until verticalspeed < 0.
        set state to hovering.
    }
    if state = hovering {
        if verticalspeed > 0 {
            seekTWR(0.9).
        } else {
            seekTWR(1.1).
        }
        if millis() > 30000 {
            stage.
            // TODO: Test low-mass Hornet T1 descent pid loop
            set throttlePID to PIDLOOP(0.008, 0.006, 0.006). // lower or higher?
            set state to descending.
        }
    }
    if state = descending {
        if verticalspeed > -5 {
            seekTWR(0.9).
        } else {
            seekTWR(1.1).
        }
        if ship:status = "landed" {
            set state to landed.
        }
    }
    if state = landed {
        unlock all.
        wait 3.
        break.
    }
    wait 0.0001.

    if abort {
        abort off.
        copypath("0:boot/hornett.boot.ks", "").
        run hornett.boot.ks.
    }
}

set ship:control:pilotmainthrottle to 0.
notify("End of test.").
