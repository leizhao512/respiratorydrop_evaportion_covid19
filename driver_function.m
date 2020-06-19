function [Evap_time,Residue_diameter,Lmax,Falling_distance] = ...
    driver_function(T,RH,Vair,d0,Parameter_File,Ini_velo)
%%
%**************************************************************************
%
%              EVAPORATION OF TRAVELING RESPIRATORY DROPLETS
%
%**************************************************************************
%If you find this code helpful, please cite the following article:
%Zhao, Lei, et al. "COVID-19: Effects of weather conditions on the 
%propagation of respiratory droplets." medRxiv (2020).
%doi: https://doi.org/10.1101/2020.05.24.20111963

%All the model formulation and parameter values can be found in the article

%This code was made and run on Matlab R2019b and some of its functions may
%require Matlab 2019b or later version.

%Make sure you provide an input a csv/xls file, which stores all the
%parameter names and values, and save it in the same folder.

%%
%This is the driver function for simulating the evaporation of a
%respiratory droplet and is used to provide adjustable weather and wind
%conditions for the following simulations. 

%The minimum input variables is 4.

%Parameters should be provided in the following manner:
%            T    ---    temperature of the environment (Kelvin),N*1 matrix
%           RH    ---    relative humidity of the environment, N*1 matrix
%          Vair   ---    air velocity, must be a N*3 matrix
%           d0    ---    the initial diameter of the droplet. The initial
%                        diameter and probability distribution of speech droplets 
%                        can be found in the supporting information of our paper.
%                        N*1 matrix
% Parameter_File  ---    the csv/xlsx file that stores all parameters, by
%                        default "input.xlsx"
%      Ini_velo   ---    initial velocity of droplets leaving respiratory
%                        tract, by default is 4.1 m/s, corresponding to
%                        speech droplets. Must be a N*3 matrix
%
%Output variables are:
%      Evap_time    ---  The time requires for the droplet to fully evaporate
%                        or fall to the level of hand.
% Residual_diameter ---  The diameter of droplet residues
%        Lmax       ---  horizontal traveling distance of the droplet before 
%                        fully evaporating or falling to the level of hand.
%                        (Detailed definition can be found in the paper)
% Falling_distance  --- distance that the droplet can fall. (Detailed 
%                       definition can be found in the paper)
%
% The size of the droplet is initialized as N1*N2*N3*N4*N5, where N1, N2, 
% N3, N4, N5 are the row dimensions of T, RH, Vair, d0, Ini_velo
%%
if nargin < 4
    error('Error: Not enough input.\n');
end
if nargin < 5
    Parameter_File = './input.xlsx';
end
if nargin < 6
    Ini_velo = [4.1,0,0];
end

%calculate the dimension of input variables
[N1,~] = size(T);
[N2,~] = size(RH);
[N3,~] = size(Vair);
[N4,~] = size(d0);
[N5,~] = size(Ini_velo);

%initialize output matrice
Evap_time = zeros(N1,N2,N3,N4,N5);
Residue_diameter = zeros(N1,N2,N3,N4,N5);
Lmax = zeros(N1,N2,N3,N4,N5);
Falling_distance = zeros(N1,N2,N3,N4,N5);

%loop over each element in T, RH,Vair matrix
for in = 1:N1
    for jn = 1:N2
        for kn = 1:N3
            for ln = 1:N4
                for mn = 1:N5
                    %check the validity of the input data
                    if T(in)<273.14 || T(in)>373.15
                        fprintf('Warning: Nonphysical temperature %6.1f found\n',T(in));
                        fprintf('Correct temperature range is 273.15-373.15 K\n');
                    end
                    if RH(jn)<0 || RH(jn)>1
                        fprintf('Warning: Nonphysical humidity %0.3f found\n',RH(jn));
                        fprintf('Correct humidity range is 0.0-1.0\n');
                    end
                    fprintf('New simulations initialized for:\n\n');
                    fprintf('Temperature %6.1f C, Humidity %3.2f\n',...
                        T(in)-273.15,RH(jn));
                    fprintf('Wind velocity (%6.2f %6.2f %6.2f) m/s\n',...
                        Vair(kn,:));
                    fprintf('Droplet initial velocity (%6.2f %6.2f %6.2f) m/s\n',...
                        Ini_velo(mn,:));
                    fprintf('Initial droplet diameter %6.1f um\n',d0(ln)*1e6);
                    %write all input parameters into Input_file
                    writematrix(T(in),Parameter_File,'Sheet','variables','Range','B2');
                    writematrix(RH(jn),Parameter_File,'Sheet','variables','Range','B4');
                    writematrix(Vair(kn,:)',Parameter_File,'Sheet','variables','Range','B13');
                    writematrix(d0(ln),Parameter_File,'Sheet','variables','Range','B5');
                    writematrix(Ini_velo(mn,:)',Parameter_File,'Sheet','variables','Range','B10');
                    %start simulations
                    travelingdrop;
                    %store output variables
                    Evap_time(mn,ln,kn,jn,in) = tevap;
                    Residue_diameter(mn,ln,kn,jn,in) = dres;
                    Lmax(mn,ln,kn,jn,in) =x0 ;
                    Falling_distance(mn,ln,kn,jn,in) = z0;
                end
            end
        end
    end
end
end
