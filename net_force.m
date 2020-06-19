function f = net_force(Parameters,Variables,d,velo,mass,v_a,Cd)
%This function is used to calculate the net force acted on the droplet 

%determine droplet radius
r = d/2; 
%initialize gravity vector
gravity = zeros(3,1);
gravity(3) = -mass*Parameters.g;
%initialize buoyancy force
buoyancy = zeros(3,1);
buoyancy(3) = mass*Parameters.g*Parameters.rho_g/Parameters.rho_d;
%calculate air drag
fdamp = -0.5*pi*r^2*Parameters.rho_m*(velo-v_a).*abs(velo-v_a)*Cd;
%CALCULATE BROWNIAN FORCE
%calculate the standard deviation
% sigma = sqrt(12*pi*Parameters.mu*r*1.38064852e-23*Variables.T_inf);
%generate a random force, each of whose component is subject to normal
%distribution
% fb = normrnd(0,sigma,3,1);
% fb = 0;
% f = gravity + buoyancy + fdamp + fb;
%update net force
f = gravity + buoyancy + fdamp;
end