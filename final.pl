%! facts
%! states
state(dormant).
state(exit).
state(init).
state(idle).
state(monitoring).
state(error_diagnosis).
state(safe_shutdown).
%! --- part2
state(boot_hw).
state(senchk).
state(tchk).
state(psichk).
state(ready).
superstate(init,boot_hw).
superstate(init,senchk).
superstate(init,tchk).
superstate(init,psichk).
superstate(init,ready).
%! --- part3
state(monidle).
state(regulate_environment).
state(lockdown).
superstate(monitoring, monidle).
superstate(monitoring, regulate_environment).
superstate(monitoring, lockdown).
%! --- part4
state(prep_vpurge).
state(alt_temp).
state(alt_psi).
state(risk_assess).
state(safe_status).
superstate(lockdown, prep_vpurge).
superstate(lockdown, alt_temp).
superstate(lockdown, alt_psi).
superstate(lockdown, risk_assess).
superstate(lockdown, safe_status).
%! --- part5
state(error_rcv).
state(applicable_rescue).
state(reset_module_data).
superstate(error_diagnosis, error_rcv).
superstate(error_diagnosis, applicable_rescue).
superstate(error_diagnosis, reset_module_data).



%! inital_state
%! --- part1
initial_state(dormant).
%! --- part2
initial_state(boot_hw).
%! --- part3
initial_state(monidle).
%! --- part4
initial_state(prep_vpurge).
%! --- part5
initial_state(error_rcv).



%! events
event(kill).
event(start).
event(init_ok).
event(begin_monitoring).
event(init_crash).
event(retry_init).
event(shutdown).
event(sleep).
event(idle_crash).
event(idle_rescue).
event(moni_rescue).
%! --- part2
event(hw_ok).
event(senok).
event(t_ok).
event(psi_ok).
%! --- part3
event(no_contagion).
event(after_100ms).
event(contagion_alert).
event(purge_succ).
%! --- part4
event(initiate_purge).
event(tcyc_comp).
event(psicyc_comp).
%! --- part5
event(apply_protocol_rescues).
event(reset_to_stable).



%! guards
guard('retry<3').
guard('retry>2').
guard('inlockdown').
guard('!inlockdown').
guard('risk>=0.01').
guard('risk<0.01').
guard('err_protocol_def').
guard('!err_protocol_def').



%! actions
%! action(name)
%! action(name, variable)
action('retry++').
action('lock_doors').
action('unlock_doors').
action('broadcast idle_err_msg').
action('broadcast moni_err_msg').
action('broadcast init_err_msg').
action('broadcast facility_crit_mesg').



%! vars
%! var(name, type)
var(retry, int).
var(inlockdown, bool).
var(risk, float).
var(err_protocol_def, bool).
var(init_err_msg, string).
var(idle_err_msg, string).
var(moni_err_msg, string).
var(facility_crit_mesg, string).



%! transitions
%! transition(state1,state2,event,guard,action)
transition(dormant,exit,kill,null,null).
transition(init,exit,kill,null,null).
transition(dormant,init,start,null,null).
transition(init,idle,init_ok,null,null).
transition(idle,exit,kill,null,null).
transition(idle,monitoring,begin_monitoring,null,null).
transition(init,error_diagnosis,init_crash,null,'broadcast init_err_msg').
transition(error_diagnosis,init,retry_init,'retry<3','retry++').
transition(error_diagnosis,exit,kill,null,null).
transition(error_diagnosis,safe_shutdown,'retry>2',null).
transition(safe_shutdown,exit,kill,null,null).
transition(safe_shutdown,dormant,sleep,null,null).
transition(idle,error_diagnosis,idle_crash,null,'broadcast idle_err_msg').
transition(error_diagnosis,idle,idle_rescue,null,null).
transition(monitoring,error_diagnosis,monitor_crash,'!inlockdown','broadcast moni_err_msg').
transition(error_diagnosis,monitoring,moni_rescue,null,null).
transition(monitoring,exit,kill,'!inlockdown',null).
%! --- part2
transition(boot_hw,senchk,hw_ok,null,null).
transition(senchk,tchk,senok,null,null).
transition(tchk,psichk,t_ok,null,null).
transition(psichk,ready,psi_ok,null,null).
%! --- part3
transition('broadcast facility_crit_mesg').
transition(monidle, regulate_environment, no_contagion, null, null).
transition(regulate_environment, monidle, after_100ms, null, null).
transition(regulate_environment, lockdown, contagion_alert, null, 'broadcast facility_crit_mesg, inlockdown :=true').
transition(lockdown, monidle, purge_succ, null, 'inlockdown := false').
transition(monitoring, error_diagnosis, monitor_crash, '!inlockdown', 'broadcast moni_err_msg').
transition(monitoring, exit, kill, '!inlockdown', null).
%! --- part4
transition(prep_vpurge, alt_temp, initiate_purge, null, 'lock_doors').
transition(prep_vpurge, alt_psi, initiate_purge, null, 'lock_doors').
transition(alt_temp, risk_assess, tcyc_comp, null, null).
transition(alt_psi, risk_assess, psicyc_comp, null, null).
transition(risk_assess, prep_vpurge, null, 'risk>=0.01', null).
transition(risk_assess, safe_status, null, 'risk<0.01', 'unlock_doors').
transition(safe_status, exit, null, null, null).
%! --- part5
transition(error_rcv, applicable_rescue, null, 'err_protocol_def', null).
transition(error_rcv, reset_module_data, null, '!err_protocol_def', null).
transition(applicable_rescue, exit, apply_protocol_rescues, null, null).
transition(reset_module_data, exit, reset_to_stable, null, null).




%! rules
%! from slides
composite_state(S) :- findall(Composite,
superstate(Composite, _), L),
list_to_set(L, S).
nested_state(S) :- superstate(_, S).

events_per_state(State, EventSet) :-
    findall(Event,
        (superstate(State, Substate),
        transition(Substate, _, Event, _, _)),
        EventList),
    list_to_set(EventList, EventSet).

included_states(S, L) :- findall(State,
(state(State), superstate(S, State)), L).

reachable(Target, Source) :- transition(Source,
Target, _, _, _).
reachable(Target, Source) :- transition(Source,
Node, _, _, _),
reachable(Target, Node).

events(EventSet) :- findall(Event,
transition(_, _, Event, _, _), EventList),
list_to_set(EventList, EventSet).

%! extended rules


%! 1
is_loop(Event, Guard) :- transition(StateA, StateA, Event, Guard, _).
%! 2
all_loops(Set) :- findall([Event,Guard], is_loop(Event,Guard), LoopList),
                  list_to_set(LoopList, Set).



%! 3
is_edge(Event, Guard) :- transition(_,_,Event,Guard,_).
%! 4
size(Length) :- findall([Event,Guard], is_edge(Event,Guard), EdgeList),
                list_to_set(EdgeList,EdgeSet),
                length(EdgeSet,Length).



%! 5
is_link(Event, Guard) :- is_edge(Event, Guard) AND !is_loop(Event, Guard).
%! 6
all_superstates(Set) :- findall(State, superstate(State,_), SuperList),
                        list_to_set(SuperList,Set).



%! 7
ancestor(Ancestor, Descendant) :- findall([Ancestor, Descendant],
                                        transition(Ancestor, Descendant,_,_,_),
                                        Ancestor).
%! 8
inheritss_transitions(State,List) :-
                    findall([Super,Other,Event,Guard,Action],
                    (superstate(Super,State), transition(Super,Other,Event,Guard,Action)),
                     List).



%! 9
all_states(L) :- findall(State, state(State), L).
%! 10
all_init_states(L) :- findall(State, init_state(State), L).
%! 11
%! getting the state that is never transitioned to...
get_starting_state(State) :- .



%! 12
state_is_reflexive(State) :- transition(State,State,_,_,_).
%! 13
%! I cannot even understand why
graph_is_reflexive :- .



%! 14
get_guards(Ret) :-  findall(Guard, guard(Guard), Ret).
%! 15
get_events(Ret) :-  findall(Event, event(Event), Ret).
%! 16
get_actions(Ret) :-  findall(Action, action(Action), Ret).




%! 17
get_only_guarded(Ret) :- findall([StateA,StateB],
                            transition(StateA, StateB, null, Guard, null),
                            Ret).
%! 18
legal_events_of(State,L) :- findall(Event,
                            transition(State,_,Event,_,_),
                            L).
