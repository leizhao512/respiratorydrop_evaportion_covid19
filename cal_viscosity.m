function mu =cal_viscosity(mu_w,mu_a,x_w,Mw)
%This function is used to calculate the dynamic viscosity of moist air
phi = (1+(mu_w/mu_a)^0.5*(28.96e-3/Mw)^0.25)^2/(8*(1+28.96e-3/Mw))^0.25;
mu = mu_w/(1+phi*x_w/(1-x_w))+mu_a/(1+phi*(1-x_w)/x_w);
end