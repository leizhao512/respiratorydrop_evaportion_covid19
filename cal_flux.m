function f = cal_flux(Parameters,Variables,d,corr,Sh,pv)
%This function is used to calculate the evaporation flux based on eq 1 in 
%"Kukkonen etc, Journal of aerosol science 20.7 (1989): 749-763."
r = d/2; 
f = 4*pi*Variables.p_tot*r*Parameters.M_w*Parameters.diffusivity*corr*Sh...
    /Parameters.R/Variables.T_inf...
    *log((Variables.p_tot-pv)/(Variables.p_tot-Variables.pv));
% f=f*0.7;
end