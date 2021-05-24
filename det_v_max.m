function [a_max]= det_a_max(e_budget,v,a,h,step_remaining)
global e_spent;
P0=0;
M=810;
global finished;
e_spent=e_spent+delta_e(v,a,h);
disp('energy spent until this step'); disp(e_spent);
e_available=e_budget-e_spent;
disp('energy left'); disp(e_available);
if e_available<=0
    finished=true;
    disp('Car runs out of energy');
end
a_max=(e_available)/(3*h*step_remaining*v*M)-P0/M;
disp('a max'); disp(a_max);
end

function [output] = delta_e(v,a,delta_t)
M=810;%Kg
P0=0;
output=(M*abs(a)*abs(v)+P0)*3*delta_t;
end

