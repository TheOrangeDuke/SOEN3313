%facts
%states
state(prep_vpurge).
state(alt_temp).
state(alt_psi).
state(risk_assess).
state(safe_status).

%events
event(initiate_purge).
event(tcyc_comp).
event(psicyc_comp).

%transition(state1,state2,event,guard,action)
transition(prep_vpurge, alt_temp, initiate_purge, null, 'lock_doors').
transition(prep_vpurge, alt_psi, initiate_purge, null, 'lock_doors').
transition(alt_temp, risk_assess, tcyc_comp, null, null).
transition(alt_psi, risk_assess, psicyc_comp, null, null).
transition(risk_assess, prep_vpurge, null, 'risk >= 1.0', null).
transition(risk_assess, safe_status, null, 'risk < 1.0', 'unlock_doors').
transition(safe_status, exit, null, null, null).

%actions
action('lock_doors').
action('unlock_doors').

%var
var(risk, float).
