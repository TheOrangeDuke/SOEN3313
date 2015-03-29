%facts
%states
state(dormant).
state(exit).
state(init).
state(idle).
state(monitoring).
state(error_diagnosis).
state(safe_shutdown).

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


%inital states
initial_state(dormant).
initial_state(boot_hw).
initial_state(monidle).
initial_state(prep_vpurge).
initial_state(error_rcv).

%events
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

%actions
%action(name)
%action(name, variable)
action('retry++').
action('broadcast idle_err_msg').
action('broadcast moni_err_msg').
action('broadcast init_err_msg').
action('lock_doors').

%var
%var(name, type)
var(retry, int).
var(init_err_msg, string).
var(idle_err_msg, string).
var(moni_err_msg, string).

%transitions
%transition(state1,state2,event,guard,action)
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


%rules

%from slides
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

%extended rules

%actions(ActionSet) :-
   % findall(Action1, action(Action), ActionList1),
   % findall(Action2, action(Action2,Variable)
