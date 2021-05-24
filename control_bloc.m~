function [a,as] = control_bloc(coord_ref,coord_deltat,coord,h,Kv,Kl,Ks)
%CONTROL_BLOC2 Same purpose as control_bloc1 but with the error of the
%speed
% Output the accelerations! 

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
a=u(1);
as=u(2);
end

