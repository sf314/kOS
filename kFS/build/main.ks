// Main run loop!!! All the things happen here!
// 1: set important variables (if not in setvars.ks)
// 2: run!!!
    // check schedule (execute command if needed)
    // check for ground command
    // check for other stuff???


set terminate to false.
set loop to 1.

on gear {
    set terminate to true.
}

cd("1:build/cpu1/exe").
until terminate {
    // Run apps and things from here
    list files.
    
    if rcs {
        // Check for ground update
        wait 0.01.
        rcs off.
    }

    print "Hello runloop " + loop.
    set loop to loop + 1.
    wait 1.
}

notify("kFS: End of program").
