// Boot script for BlueFin 1
// Load updated scripts then launch!
// Ensure that libraries are there

print "BlueFin boot".

// Libraries:
copypath("0:std/stdio.ks", "stdio.ks"). run stdio.ks.
copypath("0:std/navball.ks", "navball.ks"). run navball.ks.
copypath("0:std/Prediction.ks", "Prediction.ks"). run Prediction.ks.

// Main:
copypath("0:realsim/BlueFin1.ks", "main").
print "Running BlueFin main".
run main.