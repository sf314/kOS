// vertical launching code

lock throttle to 1.

// variables
set enteredSpace to false.

// countdown

// from {set x to 10} until x = 0 step {set x to x - 1} do {
// 	print x.
// 	wait 1.
// }

run countdown.




// staging logic
// fire stage if thrust is zero
when maxthrust = 0 then {
	print “staging”.
	wait 0.1. // wait a bit.
	stage.
	//preserve.

	if ship:orbit:periapsis < 75000 {
		preserve. // only stage again if suborbital
	}
}


// space entry
when altitude = 70000 {
	print “welcome to space!”.
	set enteredSpace to true.
}


// trigger parachutes
when enteredSpace and altitude < 4000 {
	stage.	 // if staging is next in sequence
	toggle ag1. // if in an action group
    // no preserve
}


// emergency code (if thrusters equipped at landing)
when ship:alt:radar < 1000 and enteredSpace {
    if ship:velocity:vertical > 10 {
        print "too fast"."
        set thrust to 1.
    }
}
