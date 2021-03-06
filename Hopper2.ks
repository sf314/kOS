// Try again with the hopper!
// Testing implementation of PID controller
parameter desiredAlt.
parameter hoverTime.

LOCK STEERING TO R(0,0,-90) + HEADING(90,90). // new heading thing

// Countdown
from {set x to 10.} until x = 0 step {set x to x - 1.} do {
  clearscreen.
	print x.
	wait 1.
}
clearscreen.
stage.
set condition to "Ready".



// Print func
function printVars {
  print "ALT: " + alt:radar + "                 " at (1,16).
  print "VEL: " + verticalspeed + "             " at (1, 17).
  print "CON: " + condition + "                 " at (1, 18).
}






// *** PID setup
SET g TO KERBIN:MU / KERBIN:RADIUS^2.
LOCK accvec TO SHIP:SENSORS:ACC - SHIP:SENSORS:GRAV.
LOCK gforce TO accvec:MAG / g.

// PID should take twr and output thrust
set throttlePID to PIDLOOP(0.01, 0.006, 0.006).
set throttlePID:setpoint to 1.2. // targeting 1.2g accel

print "ascending to 10m/s at 1.2g".
set condition to "Liftoff".
set thr to 0.
lock throttle to thr.
until verticalspeed > 10 {
  set thr to thr + throttlePID:Update(time:seconds, gforce).
  printVars().
  wait 0.001.
}
gear off.

print "ascending at 10m/s at 1g".
set condition to "Ascent".
set throttlePID:setpoint to 1.
until alt:radar > desiredAlt - 20 {
  set thr to thr + throttlePID:Update(time:seconds, gforce).
  printVars().
  wait 0.001.
}

print "preparing for hover".
set condition to "Prepare for hover".
set throttlePID:setpoint to 0.5.
until verticalspeed < 3 {
  set thr to thr + throttlePID:Update(time:seconds, gforce).
  printVars().
  wait 0.001.
}

print "hovering".                     // go back and forth between 1.2 and 0.8 g's
set condition to "Hover".
set throttlePID:setpoint to 1.
set time0 to time:seconds.
until time:seconds - time0 > hoverTime {

  if verticalspeed > 0 {
    set throttlePID:setpoint to 0.8.
    print "More" at (1,4).
  } else {
    set throttlePID:setpoint to 1.2.
    print "Less" at (1,4).
  }

  set thr to thr + throttlePID:Update(time:seconds, gforce).
  printVars().
  wait 0.001.
}

print "Done".





// ***** Descent to 50m above surface.
print "beginning descent at 0.8g until set descent rate".
set condition to "Begin descent".
set throttlePID:setpoint to 0.8.
until verticalspeed < -5 {
  set thr to thr + throttlePID:Update(time:seconds, gforce).
  printVars().
  wait 0.001.
}

print "descending at 1g, approx 7m/s".
set condition to "Descent".
set throttlePID:setpoint to 1.
until alt:radar < 50 {
  set thr to thr + throttlePID:Update(time:seconds, gforce).
  printVars().
  wait 0.001.
}

print "preparing for landing...".
set condition to "Landing...".
gear on.
set throttlePID:setpoint to 1.2.
until throttle < 0.1 or ag9 {
  // if faster than 2m/s, increase twr, else, decrease twr.
  if verticalspeed < -2 {
    set throttlePID:setpoint to 1.2.
  } else {
    set throttlePID:setpoint to 0.8.
  }

  set thr to thr + throttlePID:Update(time:seconds, gforce).
  printVars().
  wait 0.001.
}

print "Landed!!!".
lock throttle to 0.
sas off.
