// Stephen Flores
// BlueFin 1 main flight software.
// Use BlueFin1.boot.ks boot script.
// Send RCS signal to initiate launch.
// v1.0: Minimal looping. More linear, script-like.
// v1.1: Tweaking for better targeting. Awesomeness!

// Data Variables

// State variables

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

// ***** State 0: Launchpad
    lock throttle to 0.
    set ship:control:pilotmainthrottle to 0.
    wait until rcs.
    rcs off.
    lockGimbal(true).
    notify("BlueFin: Launch initating."). print "Mission start: " + floor(missiontime).
    wait 3.
    
// ***** State 1: Liftoff
    notify("State 1: Liftoff"). print "Launch: " + floor(missiontime).
    sas on.
    stage. lock throttle to 1.
    wait until altitude > 1000.
    
// ***** State 2: Pitch program
    notify("State 2: Pitch program"). print "Start pitch program: " + floor(missiontime).
    sas off. wait 0.1.
    until fuelRemaining() < 0.15 {
        if altitude < 10000 {
            lock steering to heading(90, gravAngle(altitude)).
        } else {
            lock steering to heading(90, 50).
        }
        wait 0.1.
    }
    print "MECO 1: " + floor(missiontime).
    lock throttle to 0.
    stage. // Be sure the second stage is the docking port.
    
// ***** State 3: Boostback
    notify("State 3: Boostback"). print "Start boostback burn: " + floor(missiontime).
    brakes on. rcs on. // Help turning.
    lockGimbal(false).
    lock steering to heading(90, 90). wait 5.
    lock steering to heading(270, 0). wait 5.
    brakes off.
    lock throttle to 1.
    set Prediction_showArrows to false.
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
    notify("State 5: Landing"). print "Entry burn: " + floor(missiontime).
    unlock steering.
    sas on. set sasmode to "stability".
    lock throttle to 1.
    brakes on.
    until ship:velocity:surface:mag < 200 {
        if (fuelRemaining() < 0.01) {
            break.
        }
    }
    
    unlock all.
    sas off.
    rcs off.
    wait until altitude < 1200.
    
    notify("Prepare for landing"). print "Prepare for landing: " + floor(missiontime).
    stage. // Chutes in last stage.
    gear on.
    unlock all. 

    wait until ship:status = "landed".
    brakes off.
    notify("Landing complete"). print "Landed: " + floor(missiontime).
    

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

