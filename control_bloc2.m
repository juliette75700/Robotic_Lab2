function [output1,output2] = control_bloc2(xref_deltat,yref_deltat,thetaref_deltat,x_deltat,y_deltat,theta_deltat,x,y,theta,h)
%CONTROL_BLOC2 Same purpose as control_bloc1 but with the error of the
%speed
% Output the speed 
Kv=0.01;
Kl=0.1;
Ks=0.1;
v_xref=(xref_deltat-x)/h;
v_yref=(yref_deltat-y)/h;
v_thetaref=(thetaref_deltat-theta)/h;
v_x=(x_deltat-x)/h;
v_y=(y_deltat-y)/h;
v_theta=(theta_deltat-theta)/h;
ev_w=[v_xref-v_x; v_yref-v_y; v_thetaref-v_theta];
T=[cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
    0           0           1];
e_b=T*ev_w;
K=[Kv Kl 0;
    0 0 Ks];
u= K*e_b;
output1=u(1);
output2=u(2);
end

