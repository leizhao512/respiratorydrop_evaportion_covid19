function [Primitive_Solutions,Dependent_Solutions] = ...
    Runge_Kutta_Integration(Primitive_Solutions,Dependent_Solutions,...
    Parameters,Variables,v_a,k_inf,dt)
%A fourth-order Runge-Kutta numerical integration is used to update the
%primitive variables in trvelingdrop.m

temp_PS =  Primitive_Solutions;%temporary variable

%FOURTH-ORDER  RUNGE-KUTTA INTEGRATION
%FIRST GENERATION
temp_RK(1) = cal_increment(Variables,Parameters,Primitive_Solutions,...
    Dependent_Solutions,v_a);

%SECOND GENERATION
Primitive_Solutions = update_primitive(temp_PS,temp_RK(1),dt/2);
Dependent_Solutions = update_dependent(Variables,Parameters,...
    Primitive_Solutions,v_a,k_inf);
temp_RK(2) = cal_increment(Variables,Parameters,Primitive_Solutions,...
    Dependent_Solutions,v_a);

%THIRD GENERATION
Primitive_Solutions = update_primitive(temp_PS,temp_RK(2),dt/2);
Dependent_Solutions = update_dependent(Variables,Parameters,...
    Primitive_Solutions,v_a,k_inf);
temp_RK(3) = cal_increment(Variables,Parameters,Primitive_Solutions,...
    Dependent_Solutions,v_a);

%FOURTH GENERATION
Primitive_Solutions = update_primitive(temp_PS,temp_RK(3),dt);
Dependent_Solutions = update_dependent(Variables,Parameters,...
    Primitive_Solutions,v_a,k_inf);
temp_RK(4) = cal_increment(Variables,Parameters,Primitive_Solutions,...
    Dependent_Solutions,v_a);

%summation based on four steps
temp_RK(5) = Runge_Kutta_Summation(temp_RK);
Primitive_Solutions = update_primitive(temp_PS,temp_RK(5),dt);
Primitive_Solutions.time = temp_PS.time + dt;
Dependent_Solutions = update_dependent(Variables,Parameters,...
    Primitive_Solutions,v_a,k_inf);
end