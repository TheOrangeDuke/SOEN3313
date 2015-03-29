%facts
%states
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

%inital state
initial_state(boot_hw).

%events
event(hw_ok).
event(senok).
event(t_ok).
event(psi_ok).

%var

%transitions
%transition(state1,state2,event,guard,action)
transition(boot_hw,senchk,hw_ok,null,null)
transition(senchk,tchk,senok,null,null)
transition(tchk,psichk,t_ok,null,null)
transition(psichk,ready,psi_ok,null,null)
