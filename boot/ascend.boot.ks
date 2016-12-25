// ***** ASCEND Balloon FSW

// Mimic an ASU ASCEND balloon launch, complete with telemetry log
// ... but this time there will be science benefit!

// Launch on ag1

copy "std/stdlib.ks" from 0.
copy "std/stdio.ks" from 0.
run stdlib.ks.
run stdio.ks.
//copy "imu.ks" from 0.
//run imu.ks.

until ag1 {
    // Wait until release command
}
// stage.


set state to 1.
set terminate to false.
set telemstring to "".
telemetry_log("Time, Alt, Temp, Speed").
telemetry_newline().
set altOfPreviousScience to 0.
function getTelemetry {
    set telemstring to " " + millis().
    set telemstring to telemstring + ", " + alt:radar.
    set telemstring to telemstring + ", " + ship:sensors:temp.
    set telemstring to telemstring + ", " + verticalspeed.
    Telemetry_log(telemstring).
    Telemetry_newline().
}
set condition to "".
function updateDisplay {
    clearscreen.
    print "State: " + state.
    print "vSpeed: " + verticalspeed.
    print "alt: " + alt:radar.
}

until terminate {
    print "Enter Until loop".
    updateDisplay().
    if state = 1 {                  // Ascent
        // Collect data, log to telemetry
        // if altitude is multiple of 5,000 then get science
        // Listen for negative verticalspeed
        print "entered state 1".
        set condition to "Ascent".
        getTelemetry().
        if mod(alt:radar, 5000) < 100 and alt:radar > 1000 { // Do science! Conditionally...
            if alt:radar - altOfPreviousScience > 200 {
                print "State 1: Getting science".
                set condition to "Reading temperature".
                Science_readFromTag("Temp1").
                wait 0.1.
                Science_transmitFromTag("Temp1").
            }
        }
        if verticalspeed < -10 {
            print "Pop detected".
            set condition to "Pop detected".
            Telemetry_log("State2Transition"). Telemetry_newLine().
            set state to 2.
        }
    } else if state = 2 {           // Pop
        // Downward velocity detected
        // Log to output, take science
        print "Pop mode".
        Telemetry_log("Pop"). Telemetry_newLine().
        getTelemetry().
        set state to 3.
        Telemetry_log("State3Transition"). Telemetry_newLine().
    } else if state = 3 {           // Descent
        set condition to "Descent".
        print "Descent".
        // Collect data
        // Listen for desired altitude
        getTelemetry().
        if alt:radar < 3000 {
            Telemetry_log("State4Transition"). Telemetry_newLine().
            set state to 4.
        }
    } else if state = 4 {           // Parachute
        print "Parachute stage".
        ag2 on.
        set condition to "Parachute activated".
        Telemetry_log("ParachuteActivated"). Telemetry_newLine().
        getTelemetry().
    } else {                        // Emergency state
        Telemetry_log("InvalidState"). Telemetry_newLine().
        set terminate to true.
    }

    // Listen for abort
    if abort {
        Telemetry_log("Abort"). Telemetry_newLine().
        set terminate to true.
    }
    // if alt:radar < 10 {
    //     Telemetry_log("LandedConditionMet"). Telemetry_newLine().
    //     set terminate to true.
    // }
    print "end of until loop".
    wait 5.
}

Telemetry_log("End of Mission").
Telemetry_newLine().
upload("Telemetry.csv").
stage.
wait 1.
stage.
wait 1.
stage.
