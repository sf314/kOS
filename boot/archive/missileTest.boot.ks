// Firing a missile!


copypath("0:boot/missiletest.boot.ks", "").


until abs(verticalspeed) > 10 { // wait until launch
}

until false {
        lock throttle to 1.
        lock steering to heading(90,0).
}


unlock all.
