// Kerboscript altimeter thing.
// Mimicks possible return data from actual altimeter
// - pressure
// - temperature
// - altitude (both asl and radar; must supply radar alt)


// ********* ALTITUDE FUNCS ***************************************************
// Set ground height manually in setup code (requires testing)
set KSAlt_groundAltitude to 0.
function KSAlt_setGroundHeight {
    parameter gHeight.
    set KSAlt_groundAltitude to gHeight.
    // Can be set to radar alt with some frequency.
}

function KSAlt_altitude {
    return ship:altitude. // Relative to sea level
}

function KSAlt_altitudeRadar {
    return ship:altitude - KSAlt_setGroundHeight.
}

// ********** OTHER DATA ******************************************************
function KSAlt_temperature {
    return VesselSensors:temp.
}

function KSAlt_pressure {
    // Return in kPa
    return ship:dynamicPressure * 1013.
}
