// navball.ks
// Provide easy interface for compass stuff
// Inspired by/taken from KSLib

print "NavBall library".

// Untested

function navball_priv_eastFor {
    return vcrs(ship:up:vector, ship:north:vector).
}

function navball_heading {
    local pointing is ship:facing:forevector.
    local east is navball_priv_eastFor(ves).

    local trig_x is vdot(ship:north:vector, pointing).
    local trig_y is vdot(east, pointing).

    local result is arctan2(trig_y, trig_x).

    if result < 0 { 
        return 360 + result.
    } else {
        return result.
    }
}

function navball_pitch {
    return 90 - vang(ship:up:vector, ship:facing:forevector).
}