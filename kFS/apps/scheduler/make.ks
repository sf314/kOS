// Compile scheduler and add to exe folder

cd("1:apps/scheduler/fsw/src").
compile scheduler.ks to scheduler.ksm.
movepath("scheduler.ksm", "1:build/cpu1/exe/scheduler.ksm").
movepath("1:apps/scheduler/fsw/commandDictionary.ks", "1:build/cpu1/exe/commandDictionary.ks").
movepath("1:apps/scheduler/fsw/schedule.json", "1:build/cpu1/exe/schedule.json").

runpath("1:build/cpu1/exe/scheduler.ksm").
runpath("1:build/cpu1/exe/commandDictionary.ks").
cd(volume(1)).
