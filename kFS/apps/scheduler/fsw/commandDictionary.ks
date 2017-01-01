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

function CommandDictionary_executeCommand {
    parameter someCommand.
    print "Command Dictionary v4".
    print "Execute cmd " + someCommand.
    local cmd is someCommand.
    // Apparently if statements don't work? Or maybe they do?
    if cmd = 0 {

    }
    if cmd = 1 {
        sas off.
            unlock steering.
    }
    if cmd = 2 {
        sas on.
            unlock steering.
    }
    if cmd = 3 {
        lock steering to heading(0, 0).
            sas off.
    }
    if cmd = 4 {
        lock steering to heading(90, 0).
            sas off.
    }
    if cmd = 5 {
        lock steering to heading(180, 0).
            sas off.
    }
    if cmd = 6 {
        lock steering to heading(270, 0).
            sas off.
    }
    if cmd = 7 {
        ADCS_main().
    }
    if cmd = 8 {

    }

    if cmd = 999 {
        reboot.
    }
}
