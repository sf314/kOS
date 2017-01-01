//*** make.ks
//*** 12/29/2016
//*** Stephen Flores

//*** Purpose
// Script for setting up cFS for running
    // Note that runpath() accepts variable arguments (as long as it resolves to a string)
    //RUNPATH( file_base + file_num + file_ending, 1, 2 ).
// 1. Compile all apps and put it in MISSION/build/cpu1/exe folder
// 2. Compile runloop and place in exec folder

runpath("1:apps/make.ks").

cd("1:build").
compile main.ks.
copypath("1:build/main.ksm", "1:build/cpu1/exe/main.ksm").
cd(volume(1)). // TODO: make sure this works!
//cd("1:build/.."). // alternative
