function droplet_driver(T,RH,Vair,d0,Input_file,Ini_velo)
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

%Make sure you provide an input csv/xls file, which stores all the
%parameter names and values, and save it in the same folder.

%%
%This is the driver function for simulating the evaporation of a
%respiratory droplet and is used to provide adjustable weather and wind
%conditions for the following simulations. 

%The minimum input variables is 4.

%Parameters should be provided in the following manner:
%            T    ---    temperature of the environment (Kelvin)
%           RH    ---    relative humidity of the environment
%          Vair   ---    air velocity, must be a 3*1 matrix
%           d0    ---    the initial diameter of the droplet. The initial
%                        diameter and probability distribution of speech droplets 
%                        can be found in the supporting information of my paper.
%     Input_file  ---    the csv/xlsx file that stores all parameters, by
%                        default "input.xlsx"
%      Ini_velo   ---    initial velocity of droplets leaving respiratory
%                        tract, by default is 4.1 m/s, corresponding to
%                        speech droplets. Must be a 3*1 matrix
%%
if nargs < 4
    error('Error: Not enough input.\n');
end
if nargs < 5
    Input_file = './input.xlsx';
end
if nargs < 6
    Ini_velo = 4.1;
end

%loop over each element in T, RH,Vair matrix
for in = 1:numel(T)
    for jn = 1:numel(RH)
        for kn = 1:numel(Vair)
            for ln = 1:numel(d0)
                for mn = 1:numel(Ini_velo)
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
                    fprintf('Temperature %6.1f C, Humidity %3.2f,  Air velocity (%6.2f  %6.2f  %6.2f) m/s\n\n',...
                        T(in),RH(jn),Vair(kn));
                    %write all input parameters into Input_file
                    writematrix(T(in),Input_file,'Sheet','variables','Range','B2');
                    writematrix(RH(jn),Input_file,'Sheet','variables','Range','B4');
                    writematrix(Vair(kn),Input_file,'Sheet','variables','Range','B13');
                    writematrix(d0(ln),Input_file,'Sheet','variables','Range','B5');
                    writematrix(Ini_velo(mn),Input_file,'Sheet','variables','Range','B10');
                    %start simulations
                    travelingdrop;
                end
            end
        end
    end
end


end