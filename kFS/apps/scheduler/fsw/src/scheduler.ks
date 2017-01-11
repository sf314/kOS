//*** Scheduler.ks
//*** 12/29/2016
//*** Stephen Flores

//*** Purpose
// Provide means of executing a sequence of commands
// Given a current time, can execute commands from command dictionary
// Does not check for updates to schedule (will be done in main runloop/safe mode)

set rtsDone to false.
set rtsCmdIndex to 0.
set rtsCmdExecTime to 0.

set rtsCmdList to readjson("1:build/cpu1/exe/schedule.json")["RelativeSchedule"].

print "Compiling Scheduler_main...".
function Scheduler_main {
    // Parameters? Or just call millis()?

    if not rtsDone and rtsCmdExecTime - millis() <= 0 { // TODO: Check if this causes errors
        local rtsCurrentCmd is rtsCmdList[rtsCmdIndex].
        if rtsCmdIndex < rtsCmdList:length - 1 {
            local rtsNextCmd is rtsCmdList[rtsCmdIndex + 1].
            set rtsCmdExecTime to millis() + rtsCurrentCmd["duration"] + rtsNextCmd["buffer"].
            CommandDictionary_executeCommand(rtsCurrentCmd["cmdID"]).
            set rtsCmdIndex to rtsCmdIndex + 1.
        } else {
            set rtsCmdExecTime to millis() + rtsCurrentCmd["duration"].
            set rtsDone to true.
            CommandDictionary_executeCommand(rtsCurrentCmd["cmdID"]).
        }
    }

    if rtsDone and rtsCmdExecTime - millis() <= 0 {
        print "Schedule Complete".
        set state to safemode. // Enter safe after completing schedule.
    }
}

function Scheduler_checkForUpdates {
    // Look in updates folder for files:
    // schedule.update.json
    // CommandDictionary.update.ks
    print "Checking for updates".
    if exists("0:updates/schedule.update.json") {
        print "Found schedule update".
        set updateTitle to readjson("0:updates/schedule.update.json")["title"].
        print "Loading " + updateTitle.

        deletepath("1:build/cpu1/exe/schedule.json").
        deletepath("1:apps/scheduler/fsw/schedule.json").
        copypath("0:updates/schedule.update.json", "1:apps/scheduler/fsw/schedule.json").

        set updateTitle to readjson("1:apps/scheduler/fsw/schedule.json")["title"].
        print "Loaded " + updateTitle.

    }

    if exists("0:updates/commandDictionary.update.ks") {
        print "Found commandDictionary update".
        deletepath("1:apps/scheduler/fsw/commandDictionary.ks").    // Remove old dictionary from apps folder
        deletepath("1:build/cpu1/exe/commandDictionary.ks").        // Remove old dictionary from exe folder
        copypath("0:updates/commandDictionary.update.ks", "1:apps/scheduler/fsw/commandDictionary.ks"). // copy new to schedule folder
        rcs off.
        reboot. // *** Requires reboot
    }

    // Recompile scheduler!!!!
    runpath("1:apps/scheduler/make.ks").
    set rtsCmdList to readjson("1:build/cpu1/exe/schedule.json")["RelativeSchedule"].
}
