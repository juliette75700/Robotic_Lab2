function [output]=lowcontrol[x_t,y_t,theta_t,phi_t,x_delta_t,y_delta_t,theta_delta_t,delta_t]
%Located in the control function
%take as inputs the actual (t) and the futur (delta_t) variables (x,y,theta)
%give in outputs the speed of the back and front wheels (wr,wl,w,phi_delta_t)

r=0.256;
L=2.2;

x_dot=(x_delta_t-x_t)/delta_t;
y_dot=(y_delta_t-y_t)/delta_t;
theta_dot=(theta_delta_t-theta_t)/delta_t;
V=x_dot/cos(theta_delta_t);
phi_delta_t=atan(theta_delta_t*L/V);
phi_dot=(phi_delta_t-phi_t)/delta_t;

wr=V/r;
wl=wr;
w=phi_dot;

output=[wr,wl,w,phi_delta_t];
end
