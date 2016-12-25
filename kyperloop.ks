// Script for modelling the Kyperloop pod and pusher
// Called by kyperloop.boot, whick is called by boot.ks
// Pusher is SRB, cannot be controlled
// Pusher detachment is controlled by pod

// *** Todo:
// Test recent edits
// Create separate script and use separate computer for pusher
// Integrate/test notify() for state changes



set terminate to false.
set state to 0.
set condition to "Rest".
set coastTime to 0.
set ship:control:pilotmainthrottle to 0.
set startTime to -1.


// Setup terminal UI:
print "MET: ". // start # at(5,0)
print "State 0: ". // # at(6,1), start condition at (9,1)
print "Ground speed: ". // Start at (14,2)

until terminate {
    // Get variables for iteration of loop.
    local met is round(time:seconds - startTime).
    local gs is groundspeed.

    if state = 0 {                          // ***** Rest state *****

        on ag1 {                            // Start command
            set startTime to time:seconds.
            set state to 1.
            stage.                          // Activate pusher
            wait 0.01.
        }

        // Maybe it rebooted
        if groundspeed > 100 {              // Check system reboot,
            set state to 2.
        }
    } else if state = 1 {                   // ***** Acceleration phase *****
        // Check for conditions of switch
        set condition to "Acceleration phase".

        // Check for loss of parts

        if maxthrust < 0.1 {
            set state to 2.
            // Stage previous stage.
            stage.
            set coastTime to time:seconds.
        }
    } else if state = 2 {                   // ***** Coast phase *****
        set condition to "Coast phase".
        // Check for conditions of switch

        // Check for loss of parts

        // Condition for braking
        if time:seconds > coastTime + 1 {
            set state to 3.
        }

    } else if state = 3 {                   //  ***** Nominal brake phase *****
        set condition to "Nominal braking phase".

        // Check speeds
        if gs > 150 {                   // inf > x > 150
            if not (ag3) {
                ag3 on.
            }
        }

        if gs < 150 and gs > 50 {       // 150 > x > 50
            if not (ag4) {
                ag4 on.
            }
        }

        if gs < 50 {                    // 50 > x > 0
            if not (ag5) {
                ag5 on.
                set state to 5.
            }
        }

    } else if state = 4 {                   // ***** Emergency brake phase *****
        set condition to "Emergency brake phase".
        if ag6 {
        } else {
            ag6 on.
            set state to 5.
        }
    } else if state = 5 {                   // ***** Terminate program *****
        set condition to "Program terminated".
        set terminate to true.
    } // end of state 5






    // ***** Detect abnormalities
    if alt:radar > 10 { // Lift generated, 10m above ground: Emergency
        set state to 4.
        stage. // activate everything
        if ag6 {} else {ag6 on.}
    }


    // ***** Print variables
    clearscreen.
    if startTime >= 0 {
        print "MET: " + met.
    } else {
        print "MET: 0".
    }
    print "State " + state + ": " + condition.
    print "Ground speed: " + round(gs, 2).
    print "ax = " + imuAccelX().
    print "ay = " + imuAccelY().
    print "az = " + imuAccelZ().
    if gs > 200 {
        print "Mach " + round((gs / 331.5), 2) at(0,3).
    }

}


// ***** Action Group definition:
// AG1: [none] Used for mission start
// AG3: Drogue chutes and rear brakes
// AG4: Main chute
// AG5: Front brakes
// AG6: [emergency] All actions of AG3, AG4, and AG5
// Abort: Abort conditions (jettison pod if necessary) (retrorockets?)
