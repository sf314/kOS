// Test suborbital flight on kerbin.
// Turn starts at 10k
    // use set steering prograde instead of lock??
    // use srfprograde instead of prograde?


// helpful vars
set enteredSpace to false.
set orbiting to false.
set suborbital to true.
// ***** Rotation presets (based on up and north, the only two predefined rotations)



// calculate 






// ***** Preflight control settings
lock throttle to 1.0.
set sasmode to "stabilityAssist".
lock steering to up + R(0,0,90). // what r() values??

from {set t to 10.} until t <= 0 step {set t to t - 1.} do { // countdown
    print t + "... ".
    wait 1. // 1 second
} 


lock throttle to 1.

// big inf while loop for launch until apoapsis
print "Running Until apoapsis > 80000".
sas off.
until apoapsis > 80000 {
    // control heading
    if altitude < 10000 {                   //below 10k
        print "locking steering to up".
        lock steering to up + R(0,0,90).
    } else {            //above 10k
        print "locking steering to 45".
        lock steering to Heading(90, 45).
    }
    
    // stage when necessary
    if maxthrust = 0 {
        lock throttle to 1.0.
        print "staging".
        stage.
    }
    
    wait 0.001.
}

if apoapsis > 80000 {
    set suborbital to true.
    print "Detected suborbital flight".
    lock throttle to 0.
}





// glide to apoapsis
print "Gliding to apoapsis".
wait until altitude > 70000. // valid line?
print "altitude above 70k".
set enteredSpace to true.






// big inf while loop for circularization
print "did enter space = " + enteredSpace.

if enteredSpace {
    print "welcome to space".
    print "running until periapsis > 75k".
    until ship:orbit:periapsis > 75000 {
        print "eta: ".
        print eta:apoapsis.
        if eta:apoapsis < 30 {
            print "eta apo less than 30s".
            lock steering to prograde.
            lock throttle to 1.
        } else {
            print "eta to apo greater than 30s".
            lock throttle to 0.
        }
        
        if apoapsis > 100000 {
            print "Apoapsis exceeding 100k".
        }
        
        // stage when necessary
        if maxthrust = 0 {
            print "staging".
            stage.
        }
    }
    print "welcome to orbit!".
    lock throttle to 0. // finished orbit
    // toggle ag1. // any action groups after orbit?
}

// Print orbital stats
print "Ap = " + ship:orbit:apoapsis.
print "Pe = " + ship:orbit:periapsis.
print "Inclination = " + ship:orbit:inclination. // valid call?






// deorbit on command
on gear { // call gear command to initiate deorbit burn
    print "Deorbit sequence initiated.". 
    lock heading to retrograde.
    until periapsis < 30000 {
        lock throttle to 1.
        
        // stage when necessary
        if maxthrust = 0 {
            print "staging".
            stage.
        }
    }
    


    
    set orbiting to false.
    set suborbital to true.
    lock throttle to 0.
    print "Deorbit complete. Flight suborbital.".
}






// big inf while loop for landing
until alt:radar < 0.5 {
    // prep for atmospheric reentry
    if altitude < 30000 and altitude > 5000 {
        lock steering to retrograde.
        lock throttle to 0. // keep thrust off
    }
    
    // prep for parachute deployment
    if altitude < 5000 and verticalspeed > 1000 {
        lock steering to up.
        lock throttle to 1.
    }
    
    // deploy parachutes
    if altitude < 2000 {
        stage.
    }
    
    // if engines, use to control descent
}




lock throttle to 0.0.
unlock all.
print "Landed".




// ***** functions



// ***** Rotation presets (based on up and north, the only two predefined rotations)
set horizonEast to Heading(90, 0).
set fortyFiveEast to Heading(90, 45).



// 


// Abort function (toggled by abort)
// gives users control over vessel
on abort { // agx or something else??
    unlock all.
    set warp to 0.
}