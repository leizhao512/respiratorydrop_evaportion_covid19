%%
%**************************************************************************
%
%             EVAPORATION OF TRAVELING RESPIRATORY DROPLETS
%
%**************************************************************************
%This code is used to simulate the evaporation process of a small sized
%respiratory droplet moving in air.
%
%If you find this code helpful, please cite the following article:
%Zhao, Lei, et al. "COVID-19: Effects of weather conditions on the 
%propagation of respiratory droplets." medRxiv (2020).
%doi: https://doi.org/10.1101/2020.05.24.20111963
%
%All the model formulation and parameter values can be found in the article

%This code was made and run on Matlab R2019b and some of its functions may
%require Matlab 2019b or later version.

%Make sure you provide an input csv/xls file, which stores all the
%parameter names and values, and save it in the same folder.
%
%%
%Definition of key variables is listed below:
%     Parameters --- variable that store all material properties
%     Variables  --- store initial conditions and environmental conditions
%     Primitive_Solutions --- store all primitive variables, i.e., time,
%                             diameter, temperature, velocity, displacement
%     Dependent_Solutions --- store all dependent variables, i.e.,
%                             nondimensional numbers, drag coeff, etc.
%All the solutions are updated every 0.01(default) second.
%%
%**************************************************************************
%
%                            READING PARAMETER 
%
%**************************************************************************
fprintf('***************************************************************');
fprintf('***************************************************************\n');
%check if the parameter file exists, if not, send out error.
f1 = fopen(Parameter_File,'r');
if fopen(Parameter_File) < 0
    fprintf("Error: cannot open file: specified Parameter File does NOT exist\n");
    fclose('all');
    return;
else
    fprintf("Reading parameters from:\n    %s \n\n\n\n",Parameter_File);
    fclose(f1);
end

%read and assign parameter values to a dynamic structure
Parameter_Name  = readcell(Parameter_File,'Sheet','properties','Range','A2:A100');
Parameter_Value = readmatrix(Parameter_File,'Sheet','properties','Range','B2:B100');
for i = 1:length(Parameter_Value)
    Parameters.(Parameter_Name{i}) = Parameter_Value(i);   
end

%read and assign variable values to a dynamic structure 
Variable_Name  = readcell(Parameter_File,'Sheet','variables','Range','A2:A100');
Variable_Value = readmatrix(Parameter_File,'Sheet','variables','Range','B2:B100');
for i = 1:length(Variable_Value)
    Variables.(Variable_Name{i}) = Variable_Value(i);   
end

%extract the velocity of air
v_a = [Variables.v_ax;Variables.v_ay;Variables.v_az];
%%
%**************************************************************************
%
%                          INITIALIZATION
%
%**************************************************************************
%initialize primitive solution variables:time, position, velocity, diameter
%and temperature
i = 1;
%define time step 
dt = readmatrix(Parameter_File,'Sheet','variables','Range','B18:B18');%1e-5;
%time to update solutions
tu = 0.01;
%iterations to update solutions
di = round(tu/dt);
%diameter of nuclei
Parameters.dr = 1.0e-6;
%cut-off hright
zc = 1.753 / 2;

Primitive_Solutions = struct('time',-dt,...
    'disp',[Variables.x_0;Variables.y_0;Variables.z_0],...
    'velocity',[Variables.v_x0;Variables.v_y0;Variables.v_z0],...
    'diameter',Variables.d_0,...
    'temp',Variables.T_0);

%calculate the mole and mass fraction of water in air and on drop surface
[fmol, x_w] = cal_massfrac(Variables.RH,Variables.T_inf,Parameters.M_w,28.96e-3);
[fmol_sat,x_sat] = cal_massfrac(1.0,Primitive_Solutions(1).temp,Parameters.M_w,28.96e-3);

%UPDATE PROPERTIES FOR MOIST AIR
%calculate the density of moist air
Parameters.rho_m = Parameters.rho_g.*(1+x_w)./(1+1.609*x_w);

%calculate viscosity of water vapor
mu_w = 1.07e-5*(Variables.T_inf/273.15)^0.5;
mu_a = 1.72e-5*(Variables.T_inf/273.15)^0.74;
Parameters.mu = cal_viscosity(mu_w,mu_a,fmol,Parameters.M_w);

%calculate specific heat capacity
Parameters.cm = x_w*Parameters.c_p + (1-x_w)*Parameters.c_g;

%calculate current binary diffusivity of vapor in air 
Parameters.diffusivity = cal_diffusivity(Parameters.D_ref,...
    Parameters.T_ref,Parameters.lambda,Variables.T_inf);

%calculate Schimdt number
Variables.Sc = cal_Schmidt(Parameters.mu,Parameters.rho_m,...
    Parameters.diffusivity);

%calculate vapor pressure in ambient
Variables.pv = Variables.RH * cal_satpressure(Variables.T_inf);

%calculate mole of NaCl in the droplet
Variables.ms = 1/6*pi*(Variables.d_0^3-Parameters.dr^3)*Parameters.rho_d*Variables.c0/Parameters.Ms;

%calculate the equivalent diameter of NaCl
Variables.dc = ((Variables.ms*Parameters.Ms/2160 + 1/6*pi*Parameters.dr^3)*6/pi)^(1/3);

%calculate the saturated mole fraction of water in NaCl solution
mss = 1/6*pi*(Variables.d_0^3-Parameters.dr^3)*Parameters.rho_d*Variables.cs/Parameters.Ms;
Variables.xs = cal_saltfraction(Parameters,Variables.d_0,mss);

%calculate the thermal conductivity far away
k_inf = cal_conductivity(fmol,Variables.T_inf,Parameters.c_g,Parameters.c_p);

%initialize dependent solution variables
Dependent_Solutions = struct('k_g',[],'Pr',[],'Re',[],'Nu',[],'Sh',[],...
    'Cd',[],'corr',[],'pv',[],'dhv',[]);
Dependent_Solutions(i) = update_dependent(Variables,Parameters,...
        Primitive_Solutions(i),v_a,k_inf);
 
%clear memory space
clear Parameter_Valu Parameter_Name Variable_Value Variable_Name ans Parameter_File Parameter_Value
%%
%continue computation if the droplet does not fall below zc and it has
%not been fully evaporated.
%Will use fourth-order Runge-Kutta integration
il = 0; %set loop index to 1
fprintf('%8s (s)  %8s (um)  %8s (C)%8s (m/s)  %8s (m)   %8s (m)\n',...
    'Time','Diameter','Temp','V','Lx','Ly');
while Primitive_Solutions(i).diameter>Variables.dc && -Primitive_Solutions(i).disp(3) <= zc
    %4th-order Runge-Kutta integration
    [Primitive_Solutions(i),Dependent_Solutions(i)] = ...
        Runge_Kutta_Integration...
        (Primitive_Solutions(i),...
        Dependent_Solutions(i),...
        Parameters,Variables,v_a,k_inf,dt);
    
    %Update and print solutions at given time (every 0.01s by default)
    if mod(il,di) == 0
        i = i + 1;%i is the update indexs
        fprintf('%8.2f      %8.2f        %8.2f        %8f       %8f       %8f\n',...
            Primitive_Solutions(i-1).time,...
            Primitive_Solutions(i-1).diameter*1e6,...
            Primitive_Solutions(i-1).temp-273.15,...
            sqrt(sum((Primitive_Solutions(i-1).velocity).^2)),...
            Primitive_Solutions(i-1).disp(1),...
            -Primitive_Solutions(i-1).disp(3));
        Primitive_Solutions(i) = Primitive_Solutions(i-1);
        Dependent_Solutions(i) = Dependent_Solutions(i-1);
    end
    %update the loop index
    il = il + 1;
end
%%
%**************************************************************************
%
%                           POST-PROCESSING
%
%**************************************************************************
%export solutions at last step
tevap = Primitive_Solutions(i).time;
dres = Primitive_Solutions(i).diameter*1e6;
x0 = Primitive_Solutions(i).disp(1);
z0 = Primitive_Solutions(i).disp(3);