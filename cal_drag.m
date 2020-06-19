function Cd = cal_drag(Re)
%This function is used to calculate the drag coefficient of a droplet
%traveling in air, which is based on eq 12 in
%"Xie, X., et al, Indoor air 17.3 (2007): 211-225."
if Re > 1000
    Cd = 0.424;
else 
    Cd = 24/(Re+1e-10)*(1+1/6*Re^(2/3));
end
end