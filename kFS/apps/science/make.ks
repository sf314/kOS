//*** make.ks
//*** 12/29/2016
//*** Stephen Flores

//*** Purpose
// Compile science and add to exe folder

cd("1:apps/science/fsw/src").
compile science.ks to science.ksm.
copypath("science.ksm", "1:build/cpu1/exe/science.ksm").
runpath("1:build/cpu1/exe/science.ksm").
cd(volume(1)).
