// Main run loop!!! All the things happen here!
// 1: set important variables (if not in setvars.ks)
// 2: run!!!
    // check schedule (execute command if needed)
    // check for ground command
    // check for other stuff???

// Action Groups:
// Gear: terminate main runloop.
// RCS: [state 0] check for GS update; [state 1] exit safe.


set terminate to false.
set loop to 1.
set delayTime to 0.1.

on gear {
    set terminate to true.
}

function nominal {
    // Run apps and things from here
    Scheduler_main(). // Will control other apps via CommandDictionary

    if rcs {
        // Check for ground update
        wait 0.01.
        rcs off.
    }

    // Check for emergencies i.e. low power?

}

function safe {
    set delayTime to 5.
    if rcs { // Exit safe mode
        // Check for ground update
        // Do other safe things.
        set state to 0.
        set delayTime to 0.1.
        wait 0.1.
        rcs off.
    }
}

cd("1:build/cpu1/exe").
until terminate {

    if state = 0 {
        nominal().
    } else if state = 1 {
        safe().
    } else {
        // Invalid state.
        print "Invalid state".
        state = 1.
        safe().
    }
    print "State " + state + ", time " + round(millis(), 1).
    wait delayTime.
}

notify("kFS: End of program").
