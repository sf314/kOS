// Compile adcs and add to exe folder

cd("1:apps/adcs/fsw/src").
compile adcs.ks to adcs.ksm.
movepath("adcs.ksm", "1:build/cpu1/exe/adcs.ksm").
runpath("1:build/cpu1/exe/adcs.ksm")
cd(volume(1)).
