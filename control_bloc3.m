function [output1,output2] = control_bloc3(xref_deltat,yref_deltat,thetaref_deltat,x_deltat,y_deltat,theta_deltat,x,y,theta,h)
%CONTROL_BLOC2 Same purpose as control_bloc1 but with the error of the
%speed
% Output the accelerations! 
Kv=0.1;
Kl=0.001;%-> rapidité à réagir
Ks=0.09;% -> intensité du signal
v_xref=(xref_deltat-x)/h;
v_yref=(yref_deltat-y)/h;
v_thetaref=(thetaref_deltat-theta)/h;
v_x=(x_deltat-x)/h;
v_y=(y_deltat-y)/h;
v_theta=(theta_deltat-theta)/h;

e_w=[v_xref-v_x; v_yref-v_y; v_thetaref-v_theta];
T=[cos(theta) sin(theta) 0;
    -sin(theta) cos(theta) 0;
    0           0           1];
e_b=T*e_w;
K=[Kv 0 0;
    0 Kl Ks];
u= K*e_b;
output1=u(1);
output2=u(2);
end

