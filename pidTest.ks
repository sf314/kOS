clearscreen.
//copy boot from 0.
//run boot.
declare parameter targetAlt.
// Testing the new alt-driven pid loop!

copypath("0:SFFpidLoop.ks", ""). // Already exists if boot.ks is run
run SFFpidLoop.ks.

// Custom k-Values:
set kP to 0.005.
set kI to 0.000001.
set kD to 0.022.

// 6, 0, 10 = 406, 281
// 5.5, 0, 12 = 359, 293
// 5.3, 0, 14 = 338, 298
// 5.2, 0, 16 = 324, 300
// 5, 0, 20 = 305, 300
// 5, 0, 22 = 301, 301
// Mass: 6.7
// maxthrust: 170 kN
// twr: 3.05
// Ideal Values: 0.005, 0.00001, 0.0022

// MARK: Testing heavier vessel
// Mass: 8.9
// maxthrust: 170 kN
// twr: 2.28
// Ideal values:
// 5, 0, 22 = 282, 277
// 5, 005, 22 = 303,inf.
// 6, 0, 22 = 305, 292
// 7, 0, 20 = 329, 300
// 6, 0, 20 = 311, 290
// 5.5, 0, 20 = 300, 284
//



LOCK STEERING TO R(0,0,-90) + HEADING(90,90). // new heading thing
stage.
set thr to 0.
lock throttle to thr. // IMPORTANT!!!
// notify("Begin Mission").
toggle gear.

until stage:liquidfuel < 10 {
	set rad to alt:radar.
	set thr to SFpidLoop(targetAlt, rad). // Passing two!!!
	//print "Value of thr is " + thr.
	set mi to min(thr, 1).
	set thr to max(0, mi).
	//print "Value of thr is " + thr.
	wait 0.001.

	clearscreen.
	print "VSpeed: " + verticalspeed at (1, 1). // hahaha!!!
	print "thr:    " + thr at (1, 2).
	print "radar:  " + alt:radar at (1, 3).
	print "maxthr: " + maxthrust at (1, 4).
	print "mass:   " + mass at (1, 5).
}

lock throttle to 0.
wait 1.
stage.
toggle gear.
unlock all.

until alt:radar < 10 {
  wait 0.1.
}
notify("Bye!").
