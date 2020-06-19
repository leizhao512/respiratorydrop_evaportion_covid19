function sh = cal_Sherwood(re,sc)
%This function is used to calculate the Sherwood number based on an
%empirical solution of Reynolds number and Schmidt number
sh = 1 + 0.276*re.^0.5.*sc.^(1/3);
end