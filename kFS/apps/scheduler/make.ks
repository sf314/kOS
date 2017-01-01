//*** make.ks
//*** 12/29/2016
//*** Stephen Flores

//*** Purpose
// Compile scheduler and add to exe folder

cd("1:apps/scheduler/fsw/src").
compile scheduler.ks to scheduler.ksm.
copypath("scheduler.ksm", "1:build/cpu1/exe/scheduler.ksm").
copypath("1:apps/scheduler/fsw/commandDictionary.ks", "1:build/cpu1/exe/commandDictionary.ks").
copypath("1:apps/scheduler/fsw/schedule.json", "1:build/cpu1/exe/schedule.json").

runpath("1:build/cpu1/exe/scheduler.ksm").
runpath("1:build/cpu1/exe/commandDictionary.ks").
cd(volume(1)).
