// Equivalent to the Grasshopper mission

parameter paramAlt. // feed function a target alt.

// Stages of deployment
  // 1. Liftoff the launchpad at controlled vertical speed
  // 2. When apoapsis reaches altitude, reduce thrust to slower speed
  // 3. At altitude, dynamically control thrust to maintain altitude.
  // 4. After set period of time, descend at preset vertical speed
  // 5. At n metres above radar surface alt, reduce vertical speed to 2 m/s

// Control Variables:
set ascentSpeed to 10. // m/s
set targetAltitude to paramAlt. // m
set approachAlt to targetAltitude - 30. // m

set hoverTime to 20. // s

set descentSpeed to -10. // m/s
set descentAlt to 50. // m
set landingSpeed to -2. // m/s

set condition to "Idle".
set physicsWait to 0.00001.
set dThr to 0.01.
set dThrsens to 0.001.
set thr to 0.
lock throttle to thr.


function printVars {
  print "Alt: " at (12, 1).
  //print alt:radar at (0, 16).
  print alt:radar at (16, 1).
  print "Vel: " at (12, 2).
  print verticalspeed at (16, 2).
  print condition at (12, 3).
}


// ***** Ascend until desired altitude

lock steering to up.
set condition to "Ready".
printVars().
//set steering to R(0,90,0).
from {set x to 10.} until x = 0 step {set x to x - 1.} do {
	print x.
  printVars().
	wait 1.
}
clearscreen.
stage.

set condition to "Ascent".
until alt:radar > approachAlt { // fast approach
  // control thrust levels to maintain constant vertical velocity
  if verticalspeed < ascentSpeed {
    set thr to min(1, thr + dThr).
  } else {
    set thr to max(0, thr - dThr).
  }
  print "thr is " + thr.
  printVars().
  wait physicsWait.
}

set condition to "Slow Ascent".
until alt:radar > targetAltitude { // slow approach
  // control thrust to ascend at slower speed
  if verticalSpeed < 1 {
    set thr to min(1, thr + dThrsens).
  } else {
    set thr to max(0, thr - dThrsens).
  }
  printVars().
  wait physicsWait.
}
// After this code block ends, you will have reached targetAltitude






// ***** Maintain altitude for n seconds
set startTime to sessionTime.
set deltaTime to 0.
set condition to "Hovering".

until deltaTime > hoverTime {
  if alt:radar < targetAltitude {
    set thr to min(1, thr + dThrsens).
  } else {
    set thr to max(0, thr - dThrsens).
  }
  set deltaTime to sessionTime - startTime.
  printVars().
  wait physicsWait.
}
// After this code block, n seconds have passed




// ***** Descend at controlled velocity
set condition to "Descent".

until alt:radar < descentAlt {
  if verticalspeed > descentSpeed { // descentSpeed is negative. Vert will thus be slower
    set thr to max(0, thr - dThr).
  } else {
    set thr to min(1, thr + dThr).
  }
  printVars().
  wait physicsWait.
}

set condition to "Landing".
until maxthrust < 0.1 and alt:radar < 10 { // detect at launchpad
  if verticalSpeed < landingSpeed {
    set thr to max(0, thr - dThrsens).
  } else {
    set thr to min(1, thr + dThrsens).
  }
  printVars().
  wait physicsWait.
}
// After this block, the rocket should be landed.


unlock all.
clearscreen.
print "done".

// SO BAD THINGS DON'T HAPPEN
SET SHIP:CONTROL:PILOTMAINthr TO 0.
