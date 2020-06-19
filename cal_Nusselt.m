function nu = cal_Nusselt(Re,Pr)
%This function is used to calculate the Nusselt number based on an
%empirical expression of Reynolds number and Prandtl number
nu = 1 + 0.276*Re.^0.5.*Pr.^(1/3);
end