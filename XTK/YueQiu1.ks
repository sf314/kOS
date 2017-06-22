// To the moon!!


//1. wait until ready.
// Script for executing a preplanned manoeuvre node
// Uses calculus found in ksProgramming video
// Changed from single script into a callable function
// Puts burnTimeFromDV. function into global scope, so you can use it.
// To run, call executeNode(_:continue), where continue: bool, if nodes should execute recursively

// *** Note:
// This file can take a while to run, as it takes control of the spacecraft for some time.
wait until rcs.
rcs off.
// FUNC: Returns burn time given deltaV
function burnTimeFromDV {
    parameter dV.

    // Get array of all engines on vessel, starting from bottom, called en
    list engines in en.
    // Find first engine whose isp is nonzero.
    local prevISP is 1.
    local firstEngine is en[0].
    for thing in en {
        local currentISP is thing:isp.
        if currentISP > 0.01 {
            if prevISP < 0.01 {
                // select engine
                set firstEngine to thing.
            }
        }
        set prevISP to currentISP.
    }.

    // get local vars based on current vessel
    //local force is ship:maxthrust * 1000. // Thrust in N. maxthrust returns kN.
    local f is ship:maxthrust * 1000. // He used single engine, I use full stage
    local m is ship:mass * 1000. // Starting mass in kg.
    local eC is constant():E. // const.
    local imp is firstEngine:isp. // first engine specific impulse in sec.
    local gC is 9.80665. //
    print "force is " + f.
    print "m is " + m.
    print "imp is " + imp.
    local res is gC * m * imp * (1 - eC^(-dV / (gC * imp))) / f.
    return res.
    // May have issues with vessels containting multiple engines on that stage.
}


// The actual thing.
function executeManoeuvre {

    // Takes parameter continue; if true, keep executing nodes, else quit.
    parameter continue.

    // ************************************************
    // Beginning of 'script' function (not a script anymore, but takes full control of spacecraft for some time)
    clearscreen.
    //notify("Executing next manoeuvre node...").
    print "Executing next manoeuvre node".

    // Get data for the next manoeuvre node
    set node to nextnode.
    set nodeDV to node:deltav:mag.
    set nodeBurnTime to burnTimeFromDV(nodeDV).
    print "Next node in " + round(node:eta) + " sec; dV = " + round (nodeDV).

    // Wait until one minute from manoeuvre
    wait until node:eta <= ((nodeBurnTime / 2) + 60).

    // Point towards manoeuvre node, wait.
    set nodeDirection to node:deltav.
    //lock steering to R(0,0,-90) + nodeDirection. // no rotation info.
    set sasmode to "MANEUVER". // MUCH BETTER!!!!!!!!!!!!!!!!
    until node:eta <= (nodeBurnTime / 2) {
        clearscreen.
        print node:eta / 2. // may throw error
        wait 0.5. // half-second increments
    }
    clearscreen.

    // Burn in that direction for allotted time
    // Stage if necessary
    set done to false.
    lock throttle to 1.
    until done {
        // Print vars
        clearscreen.
        print "DeltaV: " + node:deltav:mag.
        print "fuel: " + stage:liquidfuel.

        // Check staging
        if stage:liquidfuel < 0.1 {
            stage.
            if vessel:maxthrust < 0.01 {
                stage. // if engine not activated.
            }
            // If out of fuel, break.
            local check is 0.
            local lf is stage:liquidfuel.
            until lf > 0.1 {
                wait 0.1.
                set check to check + 1.
                if check > 10 {
                    set done to true.
                    break.
                }
            }
        }

        // Check remaining deltav, if less than one, stop
        if node:deltav:mag < 1 {
            set done to true.
            break.
        }

        // Check dot product of deltav vector and heading. Don't go backwards!
        if vdot(nodeDirection, node:deltav) < 0 {
            set done to true.
            break.
        }

        // Check remaining burn time, control throttle if less than 1s
        local remainingTime is node:deltav:mag.
        print "Remaining Time: " + remainingTime.
        print round(remainingTime).
        print round(node:deltav:mag).
        if burnTimeFromDV(remainingTime) < 1 {
            lock throttle to min(remainingTime, 1).
        }
    }

    clearscreen.
    //notify("Manoeuvre complete").
    print "Manoeuvre complete".

    set sasmode to "stabilityassist".
    unlock all.
    set ship:control:pilotmainthrottle to 0.
    // Remove manoeuvre.
    remove node.
    wait 3.

    // If continue, keep executing nodes
    if continue and hasNode {
        executeManoeuvre(true). // Run as function
    }


    print "stage if necessary".

}

// Then do maneuvers
until false {
    wait until rcs.
    executeNode(false).
    wait 1.
}
