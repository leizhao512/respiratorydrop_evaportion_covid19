function Primitive_Solutions = update_primitive(temp_PS,temp_RK,dt)
%This function is used to update all the primitive variables
Primitive_Solutions.time = temp_PS.time + dt;
Primitive_Solutions.diameter = temp_PS.diameter + temp_RK.dd*dt;
Primitive_Solutions.temp = temp_PS.temp + temp_RK.dtemp*dt;
Primitive_Solutions.velocity = temp_PS.velocity + temp_RK.dvelocity*dt;
Primitive_Solutions.disp = temp_PS.disp + temp_RK.dx*dt;
end