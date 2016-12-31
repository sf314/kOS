// Compile science and add to exe folder

cd("1:apps/science/fsw/src").
compile science.ks to science.ksm.
movepath("science.ksm", "1:build/cpu1/exe/science.ksm").
runpath("1:build/cpu1/exe/science.ksm").
cd(volume(1)).
