function [fmol,x] = cal_massfrac(RH,T,Mw,Ma)
%This function is used to calculate the mass fraction of water in moist air
%with relative humidity RH at temperature T, pressure is 1 atm.
%Mw is the molecular mass of water and Ma is the molecular mass of dry air

psat = cal_satpressure(T);%calculate the saturation pressure
fmol = psat*RH / 101325;%calculate the mole fraction of water
x = (fmol*Mw)/(fmol*Mw+(1-fmol)*Ma);
end