function d = cal_diffusivity(d0,t0,lambda,t)
%This function is used to calculate the temperature dependent diffusivity
%based on the equation of D/D_ref = (T/T_ref)^lambda
d = d0.*(t./t0).^lambda;
end