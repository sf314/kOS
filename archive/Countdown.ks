// Counts down from 10 and launches
// call in any other program with run countdown.
// does not automatically activate first stage

print "Launching in...".

from {set x to 10.} until x = 0 step {set x to x - 1.} do {
	print x.
	wait 1.
}
clearscreen.
print “Liftoff!”.
