// Library for saving and transmitting sensory data
// Will fail if an expected part is not on the active vessel
// So test out everything on the launch pad! (Run and discard)
// Tag your parts with a special identifier first!


// ***** 1: General functions, made to take name of part rather than identifier

// Runs the science experiment from the sensor with given tag, default index 0.
// ex. Sensors_readFromTag("Temp1")
function Science_readFromTag {
    parameter tag.
    set p to ship:partsTagged(tag)[0].
    set m to p:getModule("ModuleScienceExperiment").
    if (m:deployed) {
        print "Part {" + tag + "} is already deployed!".
    } else {m:deploy.}

    wait until m:hasData.
}

// Transmit the science from sensor with a given tag
// ex. Sensors_transmitFromTag("Temp1")
function Science_transmitFromTag {
    parameter tag.
    set p to ship:partsTagged(tag)[0].
    set m to p:getModule("ModuleScienceExperiment").
    // Make sure it has data!
    if (m:hasData) {
        m:transmit.
    } else {
        print "Part {" + tag + "} does not have data!".
    }
}

// Discard a sensor with a given tag, destroying the data
// ex. Sensors_discardFromTag("Temp1")
function Science_discardFromTag {
    parameter tag.
    set p to ship:partsTagged(tag)[0].
    set m to p:getModule("ModuleScienceExperiment").
    m:dump. // no checks needed
}

// ***** 2: Specific to sensors!

// Read from a specific temperature, if it exists
//
function Science_readTemperature {
    parameter num.
}




// Parts and things:
// Name: mk1pod; Title: Mk1 Command Pod; Tag:
// Name: sensorThermometer; Title: 2HOT Thermometer; Tag: Temp1
// Name: GooExperiment; Title: Mystery Goo™ Containment Unit; Tag: Goo1
// Name: sensorThermometer; Title: 2HOT Thermometer; Tag: Temp2
// Name: sensorBarometer; Title: PresMat Barometer; Tag: Press1
// Name: kOSMachine1m; Title: CX-4181 Scriptable Control System; Tag:
// Name: longAntenna; Title: Communotron 16; Tag:
