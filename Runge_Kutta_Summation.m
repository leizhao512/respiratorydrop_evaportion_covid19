function y = Runge_Kutta_Summation(temp_RK)
fn = fieldnames(temp_RK);
for i = 1:numel(fn)
    y.(fn{i}) = (temp_RK(1).(fn{i})/6 + temp_RK(2).(fn{i})/3 + temp_RK(3).(fn{i})/3 + temp_RK(4).(fn{i})/6);
end
end