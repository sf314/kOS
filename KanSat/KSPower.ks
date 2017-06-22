// KSPower
// Provide current power information, including capacity, power draw, and
// indication of low power (percent remaining). Perhaps calculate time
// remaining as well?

// ********** Initialize data variables ***************************************
set KSPower_remaining to 0.
set KSPower_capacity to 0.
set KSPower_ratio to 0.
set KSPower_drawRate to 0.

set KSPower_previousRemaining to 0.
set KSPower_previousRemainingTime to 0. // millis()

// ********** Functions *******************************************************
function KSPower_chargeRemaining {
    KSPower_private_update().
    return KSPower_remaining.
}

function KSPower_chargeCapacity {
    KSPower_private_update().
    return KSPower_capacity.
}

function KSPower_percentRemaining {
    // Returns value between 0 and 100 (to one decimal point)
    KSPower_private_update().
    return KSPower_ratio.
}

// ********** Private function (called by all, updates vars) ******************
function KSPower_private_update {
    set KSPower_previousRemaining to KSPower_remaining.
    list resources in rlist.
    local total is 0.
    for res in rlist {
        if res:name = "ELECTRICCHARGE" {
            set total to total + res:amount.
            set KSPower_capacity to res:capacity.
        }
    }.
    set KSPower_remaining to total.
    set KSPower_ratio to round(1000 * (KSPower_remaining / KSPower_capacity)) / 10.

    set KSPower_drawRate to (KSPower_remaining - KSPower_previousRemaining) / (millis() - KSPower_previousRemainingTime). // dA / dt
    set KSPower_previousRemainingTime to millis().
}
