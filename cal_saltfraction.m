function xw = cal_saltfraction(Parameters,d,ms)
%This function is used to calculate the mole fraction of water in the
%droplet
mass = 1/6*pi*Parameters.rho_d*(d^3-Parameters.dr^3);
xw = mass/Parameters.M_w / (ms + mass/Parameters.M_w);
end