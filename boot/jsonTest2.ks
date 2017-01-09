// Reading from a hand-created json and performing action

copypath("0:kFS/apps/Scheduler/fsw/schedule.json", "").

function executeCommand {
    parameter cmd.

    if cmd = 1 {
        print "cmd 1 executed".
    } else if cmd = 2 {
        print "cmd 2 executed".
    } else if cmd = 3 {
        print "cmd 3 executed".
    } else if cmd = 4 {
        print "cmd 4 executed".
    }
}

set globalVesselStartTime to time:seconds.
function millis {
    // Interacts with the global vessel load time.
    return time:seconds - globalVesselStartTime.
}

set rtsCmdList to readjson("schedule.json")["RelativeSchedule"].

set terminate to false.
set state to 0.
set rtsDone to false.
set atsDone to true.
set rtsCmdIndex to 0.
set rtsCmdExecTime to 0.

on rcs {
    set terminate to true.
}

// Runloop
until terminate {
    local currentTime is millis().

    if not rtsDone {                                                    // More RTS commands?
        local rtsCurrentCmd is rtsCmdList[rtsCmdIndex].

        if rtsCmdExecTime - currentTime <= 0 {                         // Time to execute?
            if rtsCmdIndex < rts:length - 1 {                           // hasNext?
                local rtsNextCmd is rtsCmdList[rtsCmdIndex + 1].
                set rtsCmdExecTime to currentTime + rtsCurrentCmd["duration"] + rtsNextCmd["buffer"].
                executeCommand(rtsCurrentCmd["cmdID"]).
                set rtsCmdIndex to rtsCmdIndex + 1.
            } else {                                                    // Last command
                // Duration of last cmd is time to set
                set rtsCmdExecTime to currentTime + rtsCurrentCmd["duration"].
                set rtsDone to true.
                executeCommand(rtsCurrentCmd["cmdID"]).
            }
        }
    }

    if rtsDone and atsDone and rtsCmdExecTime - currentTime <= 0 {
        set state to 1.
        break.
    }

    print round(currentTime, 2).
    wait 0.1.
}

// WORKS LIKE A CHARM!!!!!!!!
