//*** CommandDictionary.ks
//*** 12/31/2016
//*** Stephen Flores

//*** Purpose
// Define and execute commands passed to it
// as an argument.
// Here is where other apps will be called
// from (must set parameters for app to run
// if necessary).

//*** Note
// kFS doesn't like the 'unlock all' command

//*** Table of contents:
// Series | Package | line
// 100 | ADCS | 36 (for now)


function CommandDictionary_executeCommand {
    parameter someCommand.
    print "Command Dictionary v4".
    print "Execute cmd " + someCommand.
    local cmd is someCommand.
    // Apparently if statements don't work? Or maybe they do?
    if cmd = 0 {

    }







    // ***** ACM Commands (Series 100)
    // Set options, then execute main
    if cmd = 100 {
        set ADCS_runmode to "off".
        ADCS_main().
    }
    if cmd = 101 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "stabilityassist".
        ADCS_main().
    }
    if cmd = 102 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "prograde".
        ADCS_main().
    }
    if cmd = 103 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "retrograde".
        ADCS_main().
    }
    if cmd = 104 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "radialin".
        ADCS_main().
    }
    if cmd = 105 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "radialout".
        ADCS_main().
    }
    if cmd = 106 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "normal".
        ADCS_main().
    }
    if cmd = 107 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "antinormal".
        ADCS_main().
    }
    if cmd = 108 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "target".
        ADCS_main().
    }
    if cmd = 109 {
        set ADCS_runmode to "sas".
        set ADCS_sasmode to "antitarget".
        ADCS_main().
    }
    if cmd = 110 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 0.
        set ADCS_altitude to 90.
        ADCS_main().
    }
    if cmd = 111 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 0.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 112 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 0.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 113 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 0.
        set ADCS_altitude to -45.
        ADCS_main().
    }
    if cmd = 114 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 0.
        set ADCS_altitude to -90.
        ADCS_main().
    }
    if cmd = 115 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 45.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 116 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 45.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 117 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 45.
        set ADCS_altitude to -45.
        ADCS_main().
    }
    if cmd = 118 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 90.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 119 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 90.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 120 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 90.
        set ADCS_altitude to -45.
        ADCS_main().
    }
    if cmd = 121 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 135.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 122 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 135.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 123 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 135.
        set ADCS_altitude to -45.
        ADCS_main().
    }
    if cmd = 124 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 180.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 125 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 180.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 126 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 180.
        set ADCS_altitude to -45.
        ADCS_main().
    }
    if cmd = 127 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 225.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 128 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 225.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 129 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 225.
        set ADCS_altitude to -45.
        ADCS_main().
    }
    if cmd = 130 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 270.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 131 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 270.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 132 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 270.
        set ADCS_altitude to -45.
        ADCS_main().
    }if cmd = 133 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 315.
        set ADCS_altitude to 45.
        ADCS_main().
    }
    if cmd = 134 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 315.
        set ADCS_altitude to 0.
        ADCS_main().
    }
    if cmd = 135 {
        set ADCS_runmode to "steering".
        set ADCS_azimuth to 315.
        set ADCS_altitude to -45.
        ADCS_main().
    }
    // **** End ACM Commands

    if cmd = 999 {
        reboot.
    }
}
