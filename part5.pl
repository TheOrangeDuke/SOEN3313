%! facts
%! states
state(error_rcv).
state(applicable_rescue).
state(reset_module_data).
superstate(error_diagnosis, error_rcv).
superstate(error_diagnosis, applicable_rescue).
superstate(error_diagnosis, reset_module_data).
%! inital_state
initial_state(error_rcv).

%! events
event(apply_protocol_rescues).
event(reset_to_stable).

%! guards
guard('err_protocol_def').
guard('!err_protocol_def').

%! actions
%! action(name)
%! action(name, variable)

%! vars
%! var(name, type)
var(err_protocol_def, bool).

%! transition(state1,state2,event,guard,action)
transition(error_rcv, applicable_rescue, null, 'err_protocol_def', null).
transition(error_rcv, reset_module_data, null, '!err_protocol_def', null).
transition(applicable_rescue, exit, apply_protocol_rescues, null, null).
transition(reset_module_data, exit, reset_to_stable, null, null).
