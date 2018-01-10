// Stephen Flores
// BlueFin 1 main flight software.
// Use BlueFin1.boot.ks boot script.
// Send RCS signal to initiate launch.
// v1.0: Minimal looping. More linear, script-like.
// v1.1: Tweaking for better targeting. Awesomeness!
// v2.0: Better boostback burn logic, added suicide burn.

// Flight Functions
function gravAngle {
    parameter a. // Current altitude.
    // From 1000m @ 90deg, to 10000 @ 50deg. Linear mapping?
    local m is (-1)*(40 / 9000). // Slope. 
    return m * a + 94.
}

function fuelRemaining {
    // Create list of parts tagged "BlueFin_tank"
    // For item in list, add current and max values.
    // divide current and max.
    local tanklist is ship:partstagged("BlueFin_tank").
    local currentFuel is 0.
    local maxFuel is 0.
    for tank in tanklist {
        local reslist is tank:resources.
        for res in reslist {
            if res:name = "liquidfuel" {
                set currentFuel to currentFuel + res:amount.
                set maxFuel to maxFuel + res:capacity.
            }
        }
    }
    
    return currentFuel / maxFuel.
}

function lockGimbal {
    parameter yes.
    local enginelist is ship:partstagged("BlueFin_engine").
    for engine in enginelist {
        set engine:gimbal:lock to yes.
    }
}

print "BlueFin main".
// Reboot check:
if fuelRemaining() < 0.5 {
    // Must be at end of mission on the ground.
    shutdown.
}

// ***** State 0: Launchpad
    print "State: Launchpad".
    print "Setting pilot throttle = 0".
    print "Locking throttle = 1".
    set ship:control:pilotmainthrottle to 0.
    lock throttle to 1.
    print "Awaiting RCS signal".
    wait until rcs.
    rcs off.
    lockGimbal(false).
    notify("BlueFin: Launch initating."). print "Mission start: " + floor(missiontime).
    wait 3.
    
// ***** State 1: Liftoff
    print "State: Liftoff".
    notify("State 1: Liftoff"). print "Launch: " + floor(missiontime).
    sas on.
    print "Staging BlueFin_enginges".
    stage. 
    print "Locking throttle".
    lock throttle to 1.
    
    wait until altitude > 1000.
    
// ***** State 2: Pitch program
    print "State: Pitch program".
    notify("State 2: Pitch program"). print "Start pitch program: " + floor(missiontime).
    sas off. wait 0.1.
    until fuelRemaining() < 0.25 {
        if altitude < 10000 {
            lock steering to heading(90, gravAngle(altitude)).
        } else {
            lock steering to heading(90, 50).
        }
        wait 0.1.
    }
    print "MECO 1: " + floor(missiontime).
    lock throttle to 0. // ERR: Throttle not locking to zero.
    wait 1. 
    stage. // Be sure the second stage is the docking port. 
    
// ***** State 3: Boostback
    print "State: Boostback".
    notify("State 3: Boostback"). print "Preparing boostback burn: " + floor(missiontime).
    brakes on. rcs on. // Help turning.
    lockGimbal(false).
    
    lock steering to heading(90, 90). wait until navball_pitch() > 85.
    lock steering to heading(270, 0). wait until navball_pitch() < 20.
    
    print "Beginning burn...".
    brakes off.
    lock throttle to 1.
    set Prediction_showArrows to false.
    print "Waiting for prediction".
    wait until Prediction_impactGeoCoords():lng < -75.3. // Updates?
    lock throttle to 0. print "MECO 2: " + floor(missiontime).
    lock steering to heading(270, 90). wait 5. 
    
// ***** State 4: Coast
    notify("State 4: Coast"). print "Coast: " + floor(missiontime).
    unlock steering.
    set navmode to "surface".
    sas on. wait 1.
    set sasmode to "RETROGRADE". wait 3.
    wait until (Prediction_currentGeoCoords():lng < -74.5) or (altitude < 5000). // Mod altitude for speed
    
// ***** State 5: Landing // TODO: replace with suicide burn
    notify("State 5: Reentry"). print "Reentry burn: " + floor(missiontime).
    unlock steering.
    sas on. set sasmode to "stability".
    lock throttle to 1.
    brakes on.
    until ship:velocity:surface:mag < 200 {
        if (fuelRemaining() < 0.01) {
            print "Out of propellant!".
            break.
        }
    }
    
    unlock all.
    sas off.
    rcs off.
    
    
    
    // ********** New suicide landing section *********************************
    
    // *** Initialize
    set ship:control:pilotmainthrottle to 0.
    lock steering to R(0,0,-90) + HEADING(90,90).
    brakes off. // Disable gridfins
    lock vel to verticalspeed.
    lock m to ship:mass * 1000.
    SET g TO KERBIN:MU / KERBIN:RADIUS^2.
    
    set firstStageHeight to 40. // BlueFin H1 estimate
    lock d to alt:radar - firstStageHeight - 50. // Target ground level
    
    // *** Funcs 
    function totalMaxThrust {
        local sum to 0.
        local totalEngines is 0.
        //list engines in engineList.
        set engineList to ship:partstagged("BlueFin_engine").
        for en in engineList {
            set totalEngines to totalEngines + 1.
            set sum to (sum + en:maxthrust). // MAXTHRUST
        }
        return round(sum * 1000, 2). // Returns newtons!
    }
    function totalCurrentThrust {
        local sum to 0.
        local totalEngines is 0.
        //list engines in engineList.
        set engineList to ship:partstagged("BlueFin_engine").
        for en in engineList {
            set totalEngines to totalEngines + 1.
            set sum to (sum + en:thrust). // CURRENT THRUST
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
    
    // *** State info
    set state to 0.
    set freefall to 0.
    set burning to 1.
    set finalDescent to 2.
    
    // *** Run loop
    until false {
        if state = freefall {
            if d - suicideBurnDistance(totalMaxThrust()) < 0 {
                print "Begin suicide burn".
                set state to burning.
            }
        }
        
        if state = burning {
            // Full throttle until -10m/s. Then control.
            lock throttle to 1.
            if vel > -10 {
                set state to finalDescent.
                gear on.
            }
            
            // Emergency: 
            if fuelRemaining() < 0.005 {
                print "Out of propellant!".
                stage. // chutes
                wait until ship:status = "landed".
                break.
            }
        }
        
        if state = finalDescent {
            // Maintain constant descent speed (current speed).
            local thrPercent is ((m * g) / ship:maxthrust) / 1000. // Between zero and 1? Print to find out.
            lock throttle to thrPercent.
        }
        
        if ship:status = "landed" {
            lock throttle to 0.
            break.
        }
        
        wait 0.01.
        
        if abort {
            lock throttle to 0.
            stage. // chutes.
            wait 0.5.
        }
    }
    
    unlock all.
    rcs off.
    brakes off.
    
    set ship:control:pilotmainthrottle to 0.
    print "End of mission".
    wait 1.
    shutdown.
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // *** Old landing script
    // wait until altitude < 1200.
    // 
    // notify("Prepare for landing"). print "Prepare for landing: " + floor(missiontime).
    // stage. // Chutes in last stage.
    // gear on.
    // unlock all. 
    // 
    // wait until ship:status = "landed".
    // brakes off.
    // notify("Landing complete"). print "Landed: " + floor(missiontime).
    

// set finished to false.
// lock now to time:seconds. 
// 
// 
// until finished {
//     clearscreen. clearvecdraws().
// 
//     set nowCoords to Prediction_currentGeoCoords().
//     print "Lat: " + nowCoords:lat.
//     print "Lng: " + nowCoords:lng.
// 
//     set newCoords to Prediction_impactGeoCoords().
//     print "nLat: " + newCoords:lat.
//     print "nLng: " + newCoords:lng.
// 
//     wait 0.1. // Easy delay
// }
// print "Program terminated.".
// list files.

