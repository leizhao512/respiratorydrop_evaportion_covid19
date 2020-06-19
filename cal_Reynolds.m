function Re = cal_Reynolds(rho,mu,u,L)
%calculate Reynolds number based on parameters
Re = rho.*u.*L./mu;
end