// Code to handle a PID loop function.

// Implements PID loop function
// Important: Must be called: SFpidLoop(), not pidLoop()

// PID weights:
set kP to 0.005.
set kI to 0.0000001.
set kD to 0.0051.

// Previous iteration's vars:
set lastP to 0.
set lastT to 0.
set totalP to 0.

function SFpidLoop { // (targetVal: Double, currentVal: Double) -> Double
	declare parameter targetVal. // first parameter!!!
	parameter currentVal. // Second parameter!!!

	// set current time and P value
	set now to TIME:SECONDS.
	set P to targetVal - currentVal.

	// Data:
	set I to 0.
	set D to 0.

	// if time has passed, set I and D
	if lastT > 0 {
		set I to totalP + ( ((P + lastP) / 2) * (now - lastT)).
		set D to (P - lastP) / (now - lastT). //
	}

	// set output
	set output to (P * kP) + (I * kI) + (D * kD).

	// set for next iteration
	set lastP to P.
	set lastT to now.
	set totalP to I.

	// return
	return output.
}
