function [output] = simulator(x,y,theta,phi,v,delta_t)
%Located in the navigator function
%Take as inputs the actual (at t) variables of the position,
%orientation, and speed.
%Give as outputs the position and orientation at instant t+delta_t
L=2.2;
output=[x;y;theta]+delta_t*[v*cos(theta);
                            v*sin(theta);
                            v*tan(phi)/L];
end

