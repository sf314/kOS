//*** CommandDictionary.ks
//*** 12/30/2016
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
    print "Execute cmd " + someCommand.
    local cmd is someCommand.
    // Apparently if statements don't work? Or maybe they do?
    if cmd = 0 {
        ADCS_main().
    } else if cmd = 1 {
        lock steering to heading(90, 10).
    } else if cmd = 2 {
        unlock steering. //?
        sas on.
    } else {

    }
}
