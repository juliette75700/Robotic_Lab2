function [output1,output2] = control_bloc2(coord_ref,coord_deltat,coord,h)
%CONTROL_BLOC2 Same purpose as control_bloc1 but with the error of the
%speed
% Output the accelerations! 
Kv=0.05;
Kl=0.01;%-> rapidité à réagir
Ks=0.3;% -> intensité du signal
v_xref=(coord_ref(1)-coord(1))/h;
v_yref=(coord_ref(2)-coord(2))/h;
v_thetaref=(coord_ref(3)-coord(3))/h;
v_x=(coord_deltat(1)-coord(1))/h;
v_y=(coord_deltat(2)-coord(2))/h;
v_theta=(coord_deltat(3)-coord(3))/h;

e_w=[v_xref-v_x; v_yref-v_y; v_thetaref-v_theta];
T=[cos(coord(3)) sin(coord(3)) 0;
    -sin(coord(3)) cos(coord(3)) 0;
    0           0           1];
e_b=T*e_w;
K=[Kv 0 0;
    0 Kl Ks];
u= K*e_b;
output1=u(1);
output2=u(2);
end

