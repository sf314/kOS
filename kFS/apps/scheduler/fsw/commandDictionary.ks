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
// 0 | Basics | 22
// 100 | ADCS | 36 (for now)


function CommandDictionary_executeCommand {
    parameter someCommand.
    print "Command Dictionary v4".
    print "Execute cmd " + someCommand.
    local cmd is someCommand.

    // ***** Default Commands (Series 0)
    // For basic/emergency tasks
    if cmd = 0 {
        // Basically a no-op.
    }
    if cmd = 1 {
        // Terminate execution, exit program.
        // DO NOT RUN EXCEPT FOR MANUAL CONTROL.
        set terminate to true.
    }
    if cmd = 2 {
        // Print / log health data
        print "***** Health snapshot:".
        if state = safemode {
            print "Mode: Safe".
        } else if state = Nominal {
            print "Mode: Nominal".
        } else {
            print "Mode: Unknown".
        }
        print "Time: " + millis().
        print "ADCS: \n\t Runmode: " + ADCS_runmode.
        print "\t Sasmode: " + ADCS_sasmode.
        print "Scheduler: \n\t rtsDone: " + rtsDone.
        print "\t rtsCmdIndex: " + rtsCmdIndex.
        print "\t rtsCmdExecTime: " + rtsCmdExecTime.
        print "***** End snapshot".
    }
    if cmd = 3 {
        // Check for update to schedule (super useful!)
        rcs on.
        wait 0.01.
    }
    if cmd = 4 {
        // Danger: Assume switch to safe mode. Terminate systems. 'Halt' cmd.
        set ADCS_runmode to "off".
        ADCS_main().
        set state to safemode.
    }







    // ***** ACM Commands (Series 100)
    // Set options, then execute main
    // Warning! If a node doesn't exist, it will fail.s
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

    // The following are for use with mission-specific targets.
    // Disable ADCS first.
    // Create targets using latlng(lat, lng) initializer.
        // Access heading, distance, lat, lng, bearing,
    // Note that current vessel is at ship:geoposition.
    // ex:
        // LOCK STEERING TO LATLNG(50,20.2):ALTITUDEPOSITION(100000).
            // 50deg east, 20.2deg north.
    if cmd = 136 {
        // Target Kerbal Space Center
        set ADCS_runmode to "off". ADCS_main().
        lock steering to latlng(-74.5, -0.5):altitudePosition(65).
    }
    if cmd = 137 {
        // Target some sea-level position
        set ADCS_runmode to "off". ADCS_main().
        lock steering to latlng(45, 45).
    }

    // **** End ACM Commands

    // **** Emergency Commands
    if cmd = 998 { // Force abort mission
        abort on.
        set state to safemode.
    }
    if cmd = 999 { // Reboot
        reboot.
    }
}
