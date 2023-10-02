classdef PhysicsEngine
    
   
    
    
function a = Acceleration(state,  t)
    
    k = 10;
    b = 1;
    a = - k*state.x - b*state.v;
    
end


function output = Evaluate1(initial, t)
    
    output.dx = initial.v;
    output.dv = Acceleration(initial, t);
    
end


function output = Evaluate2(initial, t, dt, d)
    
    state.x = initial.x + d.dx*dt;
    state.v = initial.v + d.dv*dt;
    
    output.dx = state.v;
    output.dv = Acceleration(state, t+dt);
    
end


% 4th order Runge-Kutta integrator
function state = Integrate(state,  t,  dt)
    
    a = Evaluate1(state, t);
    b = Evaluate2(state, t, dt*0.5, a);
    c = Evaluate2(state, t, dt*0.5, b);
    d = Evaluate2(state, t, dt, c);
    
    dxdt = 1.0/6.0 * (a.dx + 2.0*(b.dx + c.dx) + d.dx);
    dvdt = 1.0/6.0 * (a.dv + 2.0*(b.dv + c.dv) + d.dv);
    
    state.x = state.x + dxdt*dt;
    state.v = state.v + dvdt*dt;
    
end
end