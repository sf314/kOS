// Testing json creation and reading from complex json file
switch to 0.

// Write json to archive.
set someValue to 5.
writejson(list(somevalue), "testWrite.json").

// Recover json from archive
set retrievedValue to readjson("testWrite.json")[0].
print "retrieved " + retrievedValue.

// Write example schedule to archive
set schedule to lexicon().
schedule:add("title", "My Schedule").
    set rts to list().
        set cmd1 to lexicon().
        cmd1:add("cmdID", 1).
        cmd1:add("timeOffset", 5).
        set cmd2 to lexicon().
        cmd2:add("cmdID", 2).
        cmd2:add("timeOffset", 10).
    rts:add(cmd1).
    rts:add(cmd2).
schedule:add("commandList", rts).
writejson(schedule, "testSchedule.json").

// Have a look
print schedule:dump.
until rcs {}.
rcs off.

// Read from the schedule!
set extractedTitle to readjson("testSchedule.json")["title"].
print "Value forkey 'title' is " + extractedTitle.
set extractedCommandList to readjson("testSchedule.json")["commandList"].

print "Extracting all commands in for loop".
for cmdLex in extractedCommandList {
    print cmdLex["cmdID"].
    print cmdLex["timeOffset"].
}

print "Extracting single command:".
set cmdLex to extractedCommandList[0].
print cmdLex["cmdID"].
print cmdLex["timeOffset"].
