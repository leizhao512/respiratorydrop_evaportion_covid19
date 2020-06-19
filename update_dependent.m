function Dependent_Solutions = update_dependent(Variables,Parameters,Primitive_Solutions,v_a,k_inf)
%This function is used to update all the dependent variables from primitive
%variables

%calculate the mass frction of water at current time step
fmol_sat = cal_massfrac(1.0,Primitive_Solutions.temp,Parameters.M_w,28.96e-3);
%%calculate thermal conductivity at current time step
k_a =  cal_conductivity(fmol_sat(1),Primitive_Solutions.temp,...
    Parameters.c_g,Parameters.c_p);
Dependent_Solutions.k_g = (k_inf + k_a)/2; %thermal conductivity will be updated stepwsie
%calculate all dependent variables
Dependent_Solutions.Pr = cal_Prandtl(Parameters.cm,Parameters.mu,...
    Dependent_Solutions.k_g);
Dependent_Solutions.Re = cal_Reynolds(Parameters.rho_m,Parameters.mu,...
    sqrt(sum((Primitive_Solutions.velocity-v_a).^2)),...
    Primitive_Solutions.diameter);
Dependent_Solutions.Nu = cal_Nusselt(Dependent_Solutions.Re,Dependent_Solutions.Pr);
Dependent_Solutions.Sh = cal_Sherwood(Dependent_Solutions.Re,Variables.Sc);
Dependent_Solutions.pv = cal_satpressure(Primitive_Solutions.temp) * ...
    max(cal_saltfraction(Parameters,Primitive_Solutions.diameter,Variables.ms),Variables.xs);
Dependent_Solutions.dhv = cal_latentheat(Primitive_Solutions.temp);
Dependent_Solutions.Cd = cal_drag(Dependent_Solutions.Re);
Dependent_Solutions.corr = correction_factor(Variables.T_inf,...
    Primitive_Solutions.temp,Parameters.lambda);
end