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
set rtsCmdList to readjson("schedule.json")["RelativeSchedule"].


function Scheduler_main {
    // Parameters? Or just call millis()?

    if not rtsDone and rtsCmdExecTime - currentTime <= 0 { // TODO: Check if this causes errors
        local rtsCurrentCmd is rtsCmdList[rtsCmdIndex].
        if rtsCmdIndex < rts:length - 1 {
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

    if rtsDone and rtsCmdExecTime - currentTime <= 0 {
        set state to 1. // Enter safe after completing schedule.
    }
}
