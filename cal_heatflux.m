function hf = cal_heatflux(Parameters,Variables,d,Nu,temp,lh,Eva_Flux,k_g)
%This function is used to calculate the evaporation flux based on eq 10 in 
%"Xie, X., et al, Indoor air 17.3 (2007): 211-225."
%Note that the sign of evaporation flux has been reverted in calcaulting
%evaporation flux. 
r = d/2;
hf = 4*pi*r*k_g*Nu*(Variables.T_inf-temp)...
    + lh*Eva_Flux ...
    - 4*pi*r^2*Parameters.emissivity*Parameters.sigma*(temp^4-Variables.T_inf^4);
end