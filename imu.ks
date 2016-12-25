// Mimic an IMU by returning expected data
// Requires the sensors onboard (acc, grav at minimum)
// ** Note: KSP uses a left-handed coordinate system

// Accelerometer (m/s)
// x is forward, y is (not left) right, z is up
// Returns physical acceleration of the sensor, reads 0 on at rest.
// Assumes the vectors returned from ship:facing:vector are unit vectors

set imuRoundValues to true.

function imuAccelX {
    // Returns x component of acceleration vectors
    //return ship:sensors:acc:x.
    set xComp to (ship:facing:forevector * ship:sensors:acc).
    if imuRoundValues {
        return round(xComp, 3).
    } else {
        return xComp.
    }
}

function imuAccelY { // actually z
    //return ship:sensors:acc:y.
    set yComp to (ship:facing:starvector * ship:sensors:acc).
    if imuRoundValues {
        return round(yComp, 3).
    } else {
        return yComp.
    }
}

function imuAccelZ { // actually y
    //return ship:sensors:acc:z.
    // Should return -9.8 in freefall (barring drag)
    set zComp to (ship:facing:topvector * ship:sensors:acc).
    if imuRoundValues {
        return round(zComp, 3).
    } else {
        return zComp.
    }
}

function imuAccelMag {
    return ship:sensors:acc:mag.
}

// Gyroscope
// Same axes as above, assumed to fit with Adafruit IMU
// KSP measures LEFT handed rotation, but these funcs will return as if RIGHT is used
// Measures angular velocity: angularvel returns rad/sec, but it will be converted to deg/sec

function imuGyroX {
    // Take angular velocity vector, and dot it with facing vector.
    return (ship:facing:forevector * ship:angularvel) * (-1). // needs to be flipped
    // (roll right is positive)
}

function imuGyroY {
    // (NO!)Rotation about the right(starboard) axis, which is z in-game
    // Actually returns rotation about the left (port) axis, where tilting down rotates positive about the y-axis
    return (ship:facing:starvector * ship:angularvel).
}

function imuGyroZ {
    // Returns information about rotation about up-axis, which is y in-game
    return (ship:facing:topvector * ship:angularvel) * (-1). // needs to be flipped
    // Turn left is positive
}

function imuGyroMag {
    // Return the magnitude of the angular velocity vector
    // should return same value as sqrt of squares of components
    return ship:angularvel:mag.
}







// Magnetometer (compass reading)
