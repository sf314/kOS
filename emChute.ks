// Script for emergency deploy of parachutes in case of failure of something

// Infinite loop until land
until abs(verticalspeed)  < 3 {
    local goodSpeed is false.
    local goodAlt is false.

    // Check safe speed
    if verticalSpeed < 300 {
        set goodSpeed to true.
    }

    // Check safe altitude
    if alt:radar < 5000 {
        set goodAlt to true.
    }

    // Trigger if both are true
    if goodSpeed and goodAlt {
        stage.
    }
    wait 1.
}
clearscreen.
print "Welcome home!".
