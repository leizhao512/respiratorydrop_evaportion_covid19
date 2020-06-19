function c = correction_factor(T_inf,T,lambda)
%This function is used to calculate the correction factor provided in eq 2
%of "Kukkonen etc, Journal of aerosol science 20.7 (1989): 749-763."
if T == T_inf
    c = 1;
else
    c = (2-lambda) .* (T_inf-T) ./ T_inf.^(lambda-1) ./ (T_inf.^(2-lambda) - T.^(2-lambda));
end
end