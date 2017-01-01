//*** kfs.boot.ks
//*** 12/28/2016
//*** Stephen Flores

// *** Specification
// Load default libraries
// Load kFS directory and run initialization
// Run primary kFS runloop (kFS_Main)

// Creating the Core Flight System in kOS
// Mimic the directory structure as well! (And makefiles?)

copypath("0:std", "1:std").
runpath("1:std/stdio.ks").
runpath("1:std/stdlib.ks").
    // TODO: check if these can be deleted after running


// Copy directories
copypath("0:kFS/apps", "1:apps").
copypath("0:kFS/build", "1:build").
copypath("0:kFS/setvars.ks", "1:setvars.ks").
print 1.
list files.

print "Now running programs:".

// Set vars
print 2.
runpath("1:setvars.ks").

// Make
print 3.
runpath("1:build/make.ks").

print "Setup complete, running main executable".
list files.


// Run executable
print "Running main executable: ".
cd("1:build/cpu1/exe").
runpath("main.ksm").



// *** WHAT DOES KFS DO ON STARTUP?
// Before anything, the standard libraries are loaded and run
// in a special std/ folder on local disk.
//
// Then, it copies apps/ and build/ folders as well as
// setvars.ks to the local machine.
//
// Setvars is the first kFS file to be run. It is inteded to
// instantiate any global variables necessary for kFS to run
// such as the state variable.
//
// Then 1:build/make is run, which runs 1:apps/make, then
// main.ks is compiled, and the .ksm file is copied to the
// 1:build/cpu1/exe folder.
//
// The apps/make executable is intended to have the canonical
// list of all apps that kFS will use. This makefile runs the
// individual app makefiles.
//
// Each individual app makefile compiles the app source
// files, copies them to the build/cpu1/exe folder, and runs
// them. Other miscellaneous files are copied to that same
// location as well, such as schedule.json.
//
// Finally, main is executed, where it uses the state
// variable to determine what is run. These runmodes are
// broken out to separate functions, so safe() and nominal()
// are called separately.




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
