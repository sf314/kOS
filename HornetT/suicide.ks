// Hornet T1 suicide burn test
// Uses some physics!
// Usable with ~1.8t payload
// NOTE: Be sure to set the tag of 1st stage engines to Hornet1stStage

// ********** INITIALIZE ******************************************************
wait until rcs.
rcs off.
gear off.
unlock all.
set ship:control:pilotmainthrottle to 0.
lock steering to R(0,0,-90) + HEADING(90,90).

// ********** CONTROL VARIABLES ***********************************************
set t to 0. lock throttle to t.

// ********** PHYSICS VARIABLES ***********************************************
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
lock gforce to totalCurrentThrust() / (ship:mass * g). // needed?
lock vel to verticalspeed.
lock m to ship:mass * 1000.
//lock d to alt:radar - 9.21.
lock d to alt:radar - 27.

// ********** FUNCTIONS *******************************************************
function totalMaxThrust {
    local sum to 0.
    local totalEngines is 0.
    //list engines in enlist.
    set enlist to ship:partstagged("Hornet1stStage").
    for en in enlist {
        set totalEngines to totalEngines + 1.
        set sum to (sum + en:maxthrust).
    }
    return round(sum * 1000, 2). // Returns newtons!
}
function totalCurrentThrust {
    local sum to 0.
    local totalEngines is 0.
    //list engines in enlist.
    set enlist to ship:partstagged("Hornet1stStage").
    for en in enlist {
        set totalEngines to totalEngines + 1.
        set sum to (sum + en:thrust).
    }
    return round(sum * 1000, 2). // Returns newtons!
}
function accelNeeded {
    return (vel * vel) / (2 * d). // for current altitude.
}
function thrustNeeded {
    return m * (g + ((vel * vel) / (2 * d))).
}
function suicideBurnDistance {
    parameter th.
    return (vel * vel) / (2 * ((th / m) - g)). // negative?
}
function printTelemetry {
    clearscreen.
    //set m to ship:mass * 1000.
    local thrTot is totalCurrentThrust().
    local thrMax is totalMaxThrust().
    local fGrav is round(m * g, 2).
    print "V       = " + round(vel, 2).
    print "d       = " + round(d, 2).
    print "sb.dist = " + round(suicideBurnDistance(thrMax), 2).
    print "m       = " + round(m, 2).
    print "Thr.tot = " + round(thrTot, 2).
    print "Thr.max = " + round(thrMax, 2).
    print "m*g     = " + round(fGrav, 2).
    print "twr     = " + round(thrTot / fGrav, 2).
    print "".
    print "a.calc  = " + round(accelNeeded(), 2).
    print "t.calc  = " + round(thrustNeeded(), 2).
    print "Situ    = " + ship:status.
}
function percentFuel {
    local tot is 0.
    local cap is 0.
    local reslist is stage:resources.
    for res in reslist {
        if res:name = "liquidfuel" {
            set tot to tot + res:amount.
            set cap to cap + res:capacity.
        }
    }
    return (tot / cap) * 100.
}
// ********** STATE INFORMATION ***********************************************
set state to 0.
    set launchpad to 0.
    set ascending to 1.
    set freefall to 2.
    set burning to 3.
    set landed to 4.


// ********** RUNLOOP *********************************************************
until false {
    if state = launchpad {
        wait 1.
        set t to 1.
        stage.
        wait until percentFuel() < 18.
        set t to 0.
        set state to ascending.
    }
    if state = ascending {
        set t to 0.
        wait until vel < 0.
        set state to freefall.
        ag1 on.
        stage.
    }
    if state = freefall {
        // Calculate burn distance and other measurements.
        printTelemetry().
        if d - suicideBurnDistance(totalMaxThrust()) < 0 {
            set state to burning.
        }
        //lock steering to retrograde.
    }
    if state = burning {
        printTelemetry().
        if vel < -100 {
            set t to 1.
        } else {
            // set using percentage of maxthrust!!!!!
            //lock steering to R(0,0,-90) + HEADING(90,90).
            local thrPercent is (thrustNeeded() / ship:maxthrust) / 1000. // between 0 and 1.
            print "th.% = " + thrPercent. // returning 259.38
            set t to thrPercent.
            gear on.
        }

        // Will exit upon landing.

    }




    if ship:status = "landed" {
        set t to 0.
        break.
    }
    // recover from reset
    if vel > 0 {
        set state to ascending.
    }

    if abort {
        reboot.
    }
}
unlock all.
set ship:control:pilotmainthrottle to 0.
print "End of mission".
