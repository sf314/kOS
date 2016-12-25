
// vars
set mysteer to up.
lock steering to mysteer.

// staging logic
when shouldStage then {
    print "auto-staging. Line 31.".
    stage.
    preserve.
}

clearscreen.
// prep for landing
lock mysteer to retrograde.
wait 10.

// deorbit burn
print "deorbiting".
lock throttle to 1.
wait until periapsis < 25000.
lock throttle to 0.
wait 10.
stage. // stage away last fuel tank     // gets rid of fuel but also makes clicky noises.
print "fionished deorbiting".

// deploy drogue chutes
wait  until altitude < 5000.
print "deploying drogue chutes".
stage.

// deploy main chutes
wait until alt:radar < 1000.
print "deploying main chutes".
stage.

wait until alt:radar < 10.
print "Landed!".
unlock all.



