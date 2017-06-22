// Abstraction of landing sequence (for Hornet 3T)
// Ensure that engines are tagged with Hornet1stStage

unlock all.
set ship:control:pilotmainthrottle to 0.
clearscreen.
wait until verticalspeed < 0.
sas off.

// ********** CONTROL VARIABLES ***********************************************
set t to 0. lock throttle to t.

// ********** PHYSICS VARIABLES ***********************************************
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
lock gforce to totalCurrentThrust() / (ship:mass * g). // needed?
lock vel to verticalspeed.
lock m to ship:mass * 1000.
lock d to alt:radar - 9.21.

// ********** FUNCTIONS ***********************************************
function totalMaxThrust {
    local sum to 0. local totalEngines is 0.
    set enlist to ship:partstagged("Hornet1stStage").
    for en in enlist {
        set totalEngines to totalEngines + 1.
        set sum to (sum + en:maxthrust).
    }
    return round(sum * 1000, 2). // Returns newtons!
}
function totalCurrentThrust {
    local sum to 0. local totalEngines is 0.
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

// ********** RUNLOOP *********************************************************
set state to 0.
    set freefall to 0.
    set burning to 1.
lock steering to R(0,0,-90) + HEADING(90,90).
until false {
    if state = freefall {
        if d - suicideBurnDistance(totalMaxThrust()) < 0 {
            set state to burning.
        }
        // Activate gridfins for safety
        ag1 on.
    }

    if state = burning {
        ag1 off. // Fins may mess with calculations.
        if vel < -100 {
            set t to 1.
        } else {
            // set using percentage of maxthrust!!!!!
            local thrPercent is (thrustNeeded() / ship:maxthrust) / 1000. // between 0 and 1.
            print "th.% = " + thrPercent. // returning 259.38
            set t to thrPercent.
        }
    }

    if ship:status = "landed" {
        set t to 0.
        break.
    }

    if vel > 0 {
        set state to ascending.
    }
    if abort {
        reboot.
    }
}
