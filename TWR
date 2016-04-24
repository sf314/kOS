// Test printing thrust-to-weight ratio
// Only works if the thrust vector is vertical

set grav to 9.81.

lock m to ship:mass.
lock thrust to ship:maxthrust.
set twr to 0.

until ag1 {
  clearscreen.
  print "Mass:   " + m.
  print "Thrust: " + thrust.
  set weight to m * grav.
  set twr to thrust / weight.
  print "TWR:    " + twr.
  wait 0.1.
}

// function for calculating twr

function getTWR {
  set funcThrust to ship:maxthrust. // Vars
  set weight to ship:mass * 9.81.
  set funcTWR to funcThrust / weight. // Math
  return funcTWR. // return
}



// Burn at some above twr1, then hold twr1
