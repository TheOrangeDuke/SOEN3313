%facts
%states
state(monidle).
state(regulate_environment).
state(lockdown).
superstate(monitoring, monidle).
superstate(monitoring, regulate_environment).
superstate(monitoring, lockdown).

%events
event(no_contagion).
event(after_100ms).
event(contagion_alert).
event(purge_succ).

%transition(state1,state2,event,guard,action)
action('broadcast facility_crit_mesg').
action(monidle, regulate_environment, no_contagion, null, null).
action(regulate_environment, monidle, after_100ms, null, null).
action(regulate_environment, lockdown, contagion_alert, null, 'boardcast facility_crit_mesg, inlockdown :=true').
action(lockdown, monidle, purge_succ, null, 'inlockdown := false').

action(monitoring, error_diagnosis, monitor_crash, !'inlockdown', 'broadcast moni_err_msg').
action(monitoring, exit, kill, !'inlockdown', null).

%var
var(inlockdown, bool).
var(facility_crit_mesg, string).
