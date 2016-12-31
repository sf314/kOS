//*** kfs.boot.ks
//*** 12/28/2016
//*** Stephen Flores

// *** Specification
// Load default libraries
// Load kFS directory and run initialization
// Run primary kFS runloop (kFS_Main)

// Creating the Core Flight System in kOS
// Mimic the directory structure as well! (And makefiles?)

copypath("0:std/stdio.ks", "").
copypath("0:std/stdlib.ks", "").
run stdio.ks.
run stdlib.ks.
    // TODO: check if these can be deleted after running


// Copy directories
copypath("0:kFS/apps", "").
copypath("0:kFS/build", "").
copypath("0:kFS/setvars.ks", "").

print "Now running programs:".
list files.

// Set vars
runpath("1:setvars.ks").

// Make
runpath("1:build/make.ks").

print "Setup complete, running main executable".
list files.


// Run executable
print "Running main executable: "
runpath("1:build/cpu1/exe/main.ksm").





// Notes:
// This will have a series of stored commands and scheduler just like in cFS SC app.
// App library makefile will initialize all apps and make them known to the runloop (compile them and put the .ksm file in the cpu directory)

// On startup:
// Compile apps, place in folder
// Look in archive for update to schedule

// Runloop:
// Check for ground command [RCS]. If so, halt execution, save update locally and execute.
    // Once downloaded to the computer, the file is deleted from the archive so it won't be detected again.
    // Will run verbatim whatever is inside the ground command file.
    // Can be used to override an app into running, or to force a change of state (by setting the variable)
// Look at schedule and see if condition is met to run an app
    // Some apps will run every n interval, some will run at specific times.
    // Saved as a lexicon, or perhaps use a list and iterator?
    // If at end of schedule for sequenced commands, go to safe mode (listen for ground).
// Run health apps at set intervals (?)
// Check for state switch conditions.


// *** Safe mode:
// Constantly listen for ground command
    // GC must include move to different state in order to leave safe mode


// *** Apps:
// ADCS (functions that point spacecraft, plus wait period)
// Picture/science (literally takes science data using stdio)
// Scheduler (checks to see if certain conditions are met for apps (sequenced or non-sequenced))
//
