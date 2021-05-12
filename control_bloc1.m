function [output1,output2] = control_block(x_ref,y_ref,theta_ref,x,y,theta)
%CONTROL take the values computed and planned by the simulator and the
%navigator and deduce the low level control values (v,w)
Kv=0.03;
Kl=0.001;
Ks=0.1;
e_w=[x_ref-x; y_ref-y; theta_ref-theta];
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

