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
}


// What does ADCS do? It controls where the spacecraft
// points itself, meaning it will either follow one
// of the orbital directions, hold steady, or point
// towards a certain heading.
//
// Possible function calls:
//
// ADCS_runmode = 3
// ADCS_main()
//
// ADCS_steering = "radialin"
// ADCS_main()

// ADCS_runmode = ["sas", "steering", "off"]
// ADCS_sasmode = ["prograde", "normal", "radial", "target", "stabilityassist"]
// ADCS_azimuth = 90
// ADCS_altitude = 45
// ADCS_main()
