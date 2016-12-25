// Script for testing the sensors library, Runs a temp probe, two mystery goo, and a pressure sensory
// Hello!
// Make sure there is a Temp1, Temp2, Goo1, and Prss1 onboard!
clearscreen.
include("Science.ks").

// List all parts on the current vessel.
print "List of all parts on vessel:".
for part in ship:parts {
    print "Name: " + part:name + "; Title: " + part:title + "; Tag: " + part:tag.
}


print "Sensor test:".

// First try two temp sensors
print "Temp1...".
Science_readFromTag("Temp1").
Science_transmitFromTag("Temp1").

wait 3.

print "Temp2...".
Science_readFromTag("Temp2").
Science_transmitFromTag("Temp2").

wait 3.

print "Goo1...".
Science_readFromTag("Goo1").
Science_transmitFromTag("Goo1").

wait 10.

print "Press1".
Science_readFromTag("Press1").
Science_transmitFromTag("Press1").

wait 3.

print "Done!".
