# respiratorydrop_evaportion_covid19

This code is used to simulate the evaporation process of a small sized respiratory droplet moving in air.

The detailed model formulations, parameter values and definitions can be found in our paper:
"Zhao, Lei, et al. "COVID-19: Effects of weather conditions on the propagation of respiratory droplets." medRxiv (2020).doi: https://doi.org/10.1101/2020.05.24.20111963". If you find our code helpful, please cite it.

This code was made and run on Matlab R2019b and some of its functions may require Matlab 2019b or later version.

driver_function.m is the main function, thourgh which you can get the droplet spreading information by providing key environmental parameters (temperature, humidity, wind) and initial conditions (diameter, velocity).

travelingdrop.m is the function executing the simulations. It will read all the parameters from an csv/xlsx file written by driver_function.m.

Given a reasonable distribution of respiratory droplet diameter, various occasions of expelling droplets, like sneezing, coughing, and speaking, can be assessed. 
