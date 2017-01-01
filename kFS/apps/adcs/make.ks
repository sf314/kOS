//*** make.ks
//*** 12/29/2016
//*** Stephen Flores

//*** Purpose
// Compile adcs and add to exe folder

cd("1:apps/adcs/fsw/src").
compile adcs.ks to adcs.ksm.
copypath("adcs.ksm", "1:build/cpu1/exe/adcs.ksm").
runpath("1:build/cpu1/exe/adcs.ksm").
cd(volume(1)).
