function main {
    launchStart().
    print "Lift Off!".
    ascentGuidance().
    until apoapsis > 101000 {
        ascentStaging().
    }
    stageRocket().
    lock throttle to 0.
    wait until eta:apoapsis < 59.
    circularizationBurn().
    // munarTransferBurn().
    // munarOrbitalBurn().
}

function launchStart {
    sas OFF.
    print "Guidance internal".
    lock throttle to 1.
    for i in range(0,10){
        print "Countdown: " + (10 - i).
        wait 1.
    }
    print "All systems go.".
    stageRocket().
    stageRocket().
}

function stageRocket {
    wait until stage:ready.
    stage.
}

function ascentGuidance {
    // what if we reverse the heading angles so that we can fly a space shuttle on its back similar to IRL
    until altitude > 300 {
        lock steering to up + R(0,0,180).
    }
    lock targetPitch to 88.963 - 1.03287 * alt:radar^0.409511.
    // lock steering to heading(90, targetPitch).
    
    // lock steering to R(0, (targetPitch + 225), 180).
    lock steering to R(0, (targetPitch + 225), 90).
}

function ascentStaging {
    if not(defined oldThrust) {
        global oldThrust is ship:availablethrust.
    }
    if ship:availablethrust < (oldThrust - 10) {
        until false {
            stageRocket(). wait 1.
            if ship:availableThrust > 0 { 
                break.
            }
        }
        global oldThrust is ship:availablethrust.
    }
}

function circularizationBurn {
    print "Starting Circularization burn...".
    lock steering to prograde.
    wait 5.
    until periapsis > 40000 {
        lock throttle to 1.
    }
    
    lock throttle to 0.
    //stageRocket().
    
    until periapsis > 100000 {
        lock throttle to 1.
    }

    lock throttle to 0.
}
main().