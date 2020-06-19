function k = cal_conductivity(x_w,T,c_g,c_p)
%This function is used to calculate the thermal conductivity 
Sw = 3/2*373.2;
Sa = 3/2*80.0;
Sva = 0.733*(Sw*Sa)^0.5;
Ka = 3.44e-3 + 7.52e-5*T;
Kw = -6.72e-3 + 7.49e-5*T;
cm_a = c_g*28.96e-3;
cm_w = c_p*18.02e-3;
nw2na = (Kw*18.02)/(Ka*28.96)*(cm_a+5/4*8.314)/(cm_w+5/4*8.314);
na2nw = 1/nw2na;
Ava = 0.25*(1+(nw2na*(28.96/18.02)^0.75*(1+Sw/T)/(1+Sa/T))^0.5)^2*(1+Sva/T)/(1+Sw/T);
Aav = 0.25*(1+(na2nw*(18.02/28.96)^0.75*(1+Sa/T)/(1+Sw/T))^0.5)^2*(1+Sva/T)/(1+Sa/T);
k = Kw/(1+Ava*(1-x_w)/x_w)+Ka/(1+Aav*x_w/(1-x_w));
end
