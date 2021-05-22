function [output,e_spent]= det_v_max(e_budget,e_spent,v,a,h,step_remained)
e_spent=e_spent+delta_e(v,a,h);
e_available=e_budget-e_spent;
v_max=e_available/(h*step_remained*P0);
end

function [output] = delta_e(v,a,delta_t)
M=810;%Kg
P0=7355;
output=(M*abs(a)*abs(v)+P0)*delta_t;
end

