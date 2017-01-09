//*** adcs.ks
//*** 12/29/2016
//*** Stephen Flores

//*** Purpose
// Provides logic that will determine where the
// satellite will be facing. Can act on state,
// variable, or things like altitude or sun
// exposure

// Variables (adjust these in order to adjust app behaviour)
set ADCS_runmode to "sas".
    // ["sas", "steering", "off"]
set ADCS_sasmode to "stabilityassist".
    // ["prograde", "normal", "radial", "target", "stabilityassist"] etc

set ADCS_azimuth to 90.
set ADCS_altitude to 45.


function ADCS_main {
    // Conditional statements can go here! (like ascent profiles, perhaps).
    if ADCS_runmode = "sas" {
        unlock steering.
        sas on. wait 0.5.           // TODO: is the wait necessary?
        set sasmode to ADCS_sasmode.
    }

    if ADCS_runmode = "steering" {
        sas off.
        lock steering to heading(ADCS_azimuth, ADCS_altitude).
    }

    if ADCS_runmode = "off" {
        unlock steering.
        sas off.
        rcs off.
    }

    // Add more runmodes as necessary
}


// What does ADCS do? It controls where the spacecraft
// points itself, meaning it will either follow one
// of the orbital directions, hold steady, or point
// towards a certain heading.

// ADCS_runmode = ["sas", "steering", "off"]
// ADCS_sasmode = ["prograde", "normal", "radial", "target", "stabilityassist"]
// ADCS_azimuth = 90
// ADCS_altitude = 45
// ADCS_main()


// ***** In Command Dictionary: List of ADCS Commands (series 100)
// 100: off

// 101: sas hold
// 102: sas prograde
// 103: sas retrograde
// 104: sas radial (eqivalent to alt/az 0,-90)
// 105: sas anti-radial (equivalent to alt/az 0, 90)
// 106: sas normal
// 107: sas anti-normal
// 108: sas target
// 109: sas anti-target

// 110: steering 0, 90
// 111: steering 0, 45
// 112: steering 0, 0
// 113: steering 0, -45
// 114: steering 0, -90
// 115: steering 45, 45
// 116: steering 45, 0
// 117: steering 45, -45
// 118: steering 90, 45
// 119: steering 90, 0
// 120: steering 90, -45
// 121: steering 135, 45
// 122: steering 135, 0
// 123: steering 135, -45
// 124: steering 180, 45
// 125: steering 180, 0
// 126: steering 180, -45
// 127: steering 225, 45
// 128: steering 225, 0
// 129: steering 225, -45
// 130: steering 270, 45
// 131: steering 270, 0
// 132: steering 270, -45
// 133: steering 315, 45
// 134: steering 315, 0
// 135: steering 315, -45

// 136: Add custom commands here.
