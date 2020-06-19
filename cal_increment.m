function temp_RK = cal_increment(Variables,Parameters,Primitive_Solutions,Dependent_Solutions,v_a)
%This function is used to calculate the derivative of all primitive
%variables in travelingdrop.m

%calculate the droplet mass
mass = 4/3*pi*Parameters.rho_d...
    *((Primitive_Solutions.diameter/2)^3-(Parameters.dr/2)^3);
%calculate the mass flux due to evaporation
Eva_Flux = cal_flux(Parameters,Variables,Primitive_Solutions.diameter,...
        Dependent_Solutions.corr,Dependent_Solutions.Sh,...
        Dependent_Solutions.pv);
%calculate the heat flux
Heat_Flux = cal_heatflux(Parameters,Variables,Primitive_Solutions.diameter,...
        Dependent_Solutions.Nu,Primitive_Solutions.temp,...
        Dependent_Solutions.dhv,Eva_Flux,Dependent_Solutions.k_g);  
%calculate the net force
Netforce = net_force(Parameters,Variables,Primitive_Solutions.diameter,...
    Primitive_Solutions.velocity,mass,v_a,Dependent_Solutions.Cd);
%calculate corresponding increment
temp_RK.dd = Eva_Flux/(pi*Parameters.rho_d*(Primitive_Solutions.diameter)^2/2);
temp_RK.dtemp = Heat_Flux/(mass*Parameters.c_p);
temp_RK.dvelocity = Netforce/mass;
temp_RK.dx = Primitive_Solutions.velocity;
end