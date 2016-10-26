// Test script for mock Phoenix mission in KSP

// *** Mission Spec:
// Orbital insertion
  // Launch from KSC to apoapsis = 106 orbit (400km in real mission)
  // at alt = 70k, open fairings and deploy antennas (dishes should be pointed)
  // at 1m from apoapsis, ditch stage if necessary, point prograde and burn
  // wait until periapsis is greater than 240km
  // release controls
// Science mission
  // target KSC
    // Check latitude and longitude of KSC and satellite
  // when above KSC, lock controls to pro-target, take science, transmit
  // unlock controls when passed KSC




// Controls:
set targetAltitude to 106000.
set steerCtrl to HEADING(90,90).
set throttleCtrl to 1.0.

// Variables:
  // Info on craft status
set statusMessage to "".
set statusNotes to "".
set currentStageFullCapacity to 1.
set normalVector to heading(0,0).
set radialVector to heading(0,-90).
// kscLat = -0.1 // basically
// ksclon = -74.5 // basically

// Functions:
function printInfo {
  //print thing at (column, row). // effectively (x,y) with inverted y.
  if alt:radar > 10000 {
    set a to ship:altitude / 1000.
    set a to round(a,2).
    print a + "km                " at (12,1).
    print round(ship:velocity:orbit:mag,1) + "m/s          " at (12,4).
  } else {
    print round(alt:radar,1) + "m           " at (12,1).
    print round(ship:velocity:surface:mag,1) + "m/s         " at (12,4).
  }

  print round(apoapsis) + "m        " at (12,2).      // also ship:orbit:apoapsis
  print "in " + round(eta:apoapsis,1) + "         " at (25,2).

  print round(periapsis) + "m            " at (12,3).
  print "in " + round(eta:periapsis,1)  + "         " at (25,3).

  print statusMessage  + "                      " at (8,6).
  print statusNotes + "                  " at (8,7).

  // Look:
// Alt[radar]: 10328.3m
// Apoapsis:   120849m      in 67.5s
// Periapsis:  80329m       in 400.9s
// Vel[surf]:  1200m/s
//
// Status: Pitching to 45 degrees
//         Angle: 66.2

}

function gravAngle { // calculate angle for gravity turn, return it
  parameter x.
  if x < 3000 {
    set statusMessage to "Liftoff".
    set statusNotes to "Waiting until 3,000m altitude".
    //set steerCtrl to HEADING(90,90).
    //lock steering to heading(90,90).
    return 90.
  } else if x > 3000 and x < 10000 {
    set statusMessage to "Beginning gravity turn".
    set theta to -0.00642857 * x + 109.2857.
    //set steerCtrl to HEADING(90,theta).
    //lock steering to HEADING(90,theta).
    set statusNotes to "Theta = " + round(theta,1).
    return theta.
  } else {
    set statusMessage to "Primary ascent".
    set theta to -0.0004687 * x + 49.6875.
    //set steerCtrl to HEADING(90,theta).
    //lock steering to HEADING(90,theta).
    set statusNotes to "Theta = " + round(theta,1).
    return theta.
  }
}

















// ***** Part 1: Ascent

// Countdown
clearscreen.
from {local t is 10.} until t <= 0 step {set t to t - 1.} do {
    print "Launching in " + t.
    wait 1.
    clearscreen.
}

print "Alt:" at (1,1).
print "Vel:" at (1,4).
print "Apoapsis:" at (1,2).
print "Periapsis:" at (1,3).
print "Status:" at (1,6).

// Launch sequence:
lock steering to steerCtrl.
set steerCtrl to heading(90,90).
//lock throttle to throttleCtrl.
lock throttle to 0.8.
set currentStageFullCapacity to stage:liquidfuel.
stage.

// Gravity turn logic
until ship:orbit:apoapsis > targetAltitude {
  set angle to gravAngle(altitude).  // set heading
  set steerCtrl to HEADING(90,angle).
  //lock steering to HEADING(90,angle).
  if stage:liquidfuel < 0.1 and throttle > 0.1 { // stage if necessary
    stage.
    wait 0.1.
    set currentStageFullCapacity to stage:liquidfuel.
  }
  printInfo().
}
set throttleCtrl to 0.
lock throttle to 0.

// wait, check fuel, stage
wait 2.
if stage:liquidfuel < currentStageFullCapacity / 10 {
  stage.
  set currentStageFullCapacity to stage:liquidfuel.
  set statusMessage to "Staging".
  set statusNotes to "Stage was at 10% of full capacity".
}
printInfo().
wait 5.





// Coast period
set statusMessage to "Coast period".
until eta:apoapsis < 30 or periapsis > targetAltitude - 5000{
  set statusNotes to "Waiting until apoapsis, in t-" + round(eta:apoapsis).
  printInfo().
}









// ***** Part 2; Circularization
lock steering to prograde.
set statusMessage to "Circularization".
until periapsis > targetAltitude - 5000 {
  if eta:apoapsis < 30 {
      set statusNotes to "Burn increase".
      set add to throttle + 0.01.
      lock throttle to min(1, add).
  } else {
      if periapsis > 0 {
          set statusNotes to "Final burn".
          lock throttle to 1.
      } else {
          set statusNotes to "Burn decrease".
          set sub to throttle - 0.01.
          lock throttle to max(0, sub).
      }
  }
  if stage:liquidfuel < 0.1 {
    stage.
    wait 0.001.
  }
  printInfo().
}
wait 0.1.
lock throttle to 0.
wait 3.
lock throttle to 0.
stage.
wait 0.1.
stage.
wait 0.1.







// ***** Part 3: Science

// default to normal direction, release afterward. (VCRS(SHIP:VELOCITY:ORBIT, BODY:POSITION)).
    // or SET SASMODE TO "RADIALIN".
    // also prograde, retrograde, normal, antinormal, radialout, radialin, target, antitarget, maneuver,stabilityassist, and stability.
    // better to use heading(0,-90) for radial, and heading(0,0) for normal.
// target radial for KSC

set picturesTaken to 0.
set approachingKSC to false.
//set camera to ship:partsnamed("NameOfCamera")[0].
//set moduleCamera to camera:getmodule("modulescienceexperiment"). // in Tundra???
//set tempsensor to ship:partsnamed("")[0].
//set moduleTemp to tempsensor:getmodule("modulescienceexperiment").
set isDay to true.

until picturesTaken > 2 {
  set lat to ship:latitude.
  set lon to ship:longitude.
  set statusNotes to "Coord: " + round(lat) + ":" + round(lon).

  // Check approach status
  if lon > -90 and lon < -60 {
    set approachingKSC to true.
    set statusMessage to "Approaching KSC".
  } else {
    set approachingKSC to false.
    set statusMessage to "Not in range of KSC".
  }

  // Deal with darkness
  if ship:sensors:light < 0.1 {
    set approachingKSC to false.
  }

  // Science
  if approachingKSC {
    if lon > -80 and lon < -70 {
      lock steering to radialVector.
      if lat > -5 and lat < 5 {
        set statusMessage to "Imaging surface around KSC".
        set statusNotes to "Coordinates: (" + round(lat,1) + ":" + round(lon,1) + ")".
        // Take picture !!!
        //moduleCamera:deploy.
        //wait until moduleCamera:hasData.
        wait 10.
        set picturesTaken to picturesTaken + 1.
        //moduleCamera:transmit.
      } else {
        set statusMessage to "Locking controls toward KSC".
        set statusNotes to "Waiting for image capture opportunity".
      }
    } else {
      set statusMessage to "Waiting for alignment with KSC".
      set statusNotes to "".
    }
  }

  // loop delay control
  if approachingKSC {
    wait 3.
  } else {
    lock steering to normalVector.
    if ship:sensors:light > 0.001 {
        set isDay to true.
    }

    // dealing with darkness
    if ship:sensors:light < 0.001  and isDay {
      set statusNotes to "Attempting to reorient to sun".
      lock steering TO LOOKDIRUP( V(0,1,0), SUN:POSITION ).
      wait 5.
      if ship:sensors:light < 0.001 {
          set isDay to false.
          set statusNotes to "Nighttime".
      }
    } else {
      wait 60.
    }
  }
  printInfo().
}
