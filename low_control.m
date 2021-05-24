function low_control(h,e_budget, step_remaining,coord_ref,coord_deltat,coord)
global e_spent v ws a stop;
e_spent=e_spent+delta_e(v,a,h);
v_lim=9;
if stop==false
  [a,as]=control_bloc(coord_ref,coord_deltat,coord,h,0.01,0.01,0.3);
else 
  [a,as]=control_bloc(coord_ref,coord_deltat,coord,h,0.05,0.001,0.03);
end

a=lim_acc(v,a,h,step_remaining,e_budget);
[v,ws]=lim_speed(v,ws,a,as,h,v_lim);
end

function [output] = delta_e(v,a,delta_t)
M=810;%Kg
P0=1000;
output=(M*abs(a)*abs(v)+P0)*3*delta_t;
end

function [v,ws]=lim_speed(v,ws,a,as,h,v_lim)
    if v+a*h>v_lim
         v=v_lim;
    else
        v=v+a*h;
        if v<0
            v=0;
        end
    end
    ws=ws+as*h;
 end

function [a]=lim_acc(v,a,h,step_remaining,e_budget)
    a_max=det_a_max(e_budget,a,v,2*h,step_remaining);
    if abs(a)>a_max
        if a>0
            a=a_max;
        else
            a=-a_max;
        end
    else
        a=a;
    end
end

function [a_max]= det_a_max(e_budget,a,v,h,step_remaining)
global finished e_spent stop;
P0=1000;
M=810;
e_available=e_budget-e_spent;
if e_available<=100
    finished=true;
    disp('Car runs out of energy');
    a_max=0;
    return;
end
if stop==true && a<0
    a_max=(e_available+1.5*10^4)/(3*h*step_remaining*v*M)-P0/M;
else    
    a_max=max((e_available-1.5*10^4)/(3*h*step_remaining*v*M)-P0/M,0);
end
end