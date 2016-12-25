// Test the imu in boot loop

include("imu.ks").

clearscreen.
set tPrev to millis().
set velx to 0.
set vely to 0.
set velz to 0.
set xvelocity to 0.

until abort {
    // Get sensory data.
    set ax to imuAccelX().
    set ay to imuAccelY().
    set az to imuAccelZ().
    set amag to imuAccelMag().

    // Set change in time (for derivatives)
    set tNow to millis().
    set dT to tNow - tPrev.

    // Round variables for clarity.
    set ax to round(ax * 100) / 100. print "ax = " + ax  + "          " at(0, 0).
    set ay to round(ay * 100) / 100. print "ay = " + ay  + "          " at(0, 1).
    set az to round(az * 100) / 100. print "az = " + az  + "          " at(0, 2).
    set amag to round(amag * 100) / 100. print "am = " + amag + "          " at(0,3).

    // Calculate velocity given change in time between loops.
    // 1. Find dT (above)
    // 2. Find derivatives of acceleration at points
    // print dT at(0,4).
    //
    // set vx to ax * dT. print "vx = " + vx + "          " at (0, 6).
    // set vy to ay * dT. print "vy = " + vy + "          " at (0, 7).
    // set vz to az * dT. print "vz = " + vz + "          " at (0, 8).
    // set vm to sqrt(vx * vx + vy * vy + vz * vz). print "vm = " + vm + "         " at (0,9).
    //
    // // Calculate using formula from thing
    // set xvelocity to xvelocity + dT * ax. // WORKS! To some degree of accuracy.
    // print xvelocity at (0,10).
    // print sqrt(verticalspeed * verticalspeed + groundspeed * groundspeed) at (0,11).






    // Gyroscope information.
    set gx to imuGyroX().
    set gy to imuGyroY().
    set gz to imuGyroZ().
    set gm to imuGyroMag().

    set gx to round(gx * 100) / 100. print "gx = " + gx + "         " at (0, 5).
    set gy to round(gy * 100) / 100. print "gy = " + gy + "         " at (0, 6).
    set gz to round(gz * 100) / 100. print "gz = " + gz + "         " at (0, 7).
    set gm to round(gm * 100) / 100. print "gm = " + gm + "         " at (0, 8).

    // Set variables for next pass.
    set tPrev to tNow.
}

clearscreen.
