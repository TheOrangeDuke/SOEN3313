%! facts
%! states
state(monidle).
state(regulate_environment).
state(lockdown).
superstate(monitoring, monidle).
superstate(monitoring, regulate_environment).
superstate(monitoring, lockdown).
%! inital_state
initial_state(monidle).

%! events
event(no_contagion).
event(after_100ms).
event(contagion_alert).
event(purge_succ).

$guards
guard('inlockdown').

%! actions
%! action(name)
%! action(name, variable)
action('broadcast facility_crit_mesg').

%! vars
%! var(name, type)
var(inlockdown, bool).
var(facility_crit_mesg, string).

%! transition(state1,state2,event,guard,action)
transition('broadcast facility_crit_mesg').
transition(monidle, regulate_environment, no_contagion, null, null).
transition(regulate_environment, monidle, after_100ms, null, null).
transition(regulate_environment, lockdown, contagion_alert, null, 'broadcast facility_crit_mesg, inlockdown :=true').
transition(lockdown, monidle, purge_succ, null, 'inlockdown := false').
transition(monitoring, error_diagnosis, monitor_crash, !'inlockdown', 'broadcast moni_err_msg').
transition(monitoring, exit, kill, !'inlockdown', null).
