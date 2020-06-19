function p = cal_satpressure(T)
%This function is used to evaluate the saturation vapor pressure of water
%at different T.
p = exp(77.34-(7235./T)-8.2.*log(T)+0.005711.*T);
end