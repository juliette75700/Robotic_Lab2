function [output1,output4] = simulator(coord,v,ws,delta_t,phi)
%Located in the navigator function
%Take as inputs the actual (at t) variables of the position,
%orientation, and speed.
%Give as outputs the position and orientation at instant t+delta_t
L=2.2;
phi=phi+ws*delta_t;
if phi>pi/8
    phi=pi/8;
end 
if phi<-pi/8
    phi=-pi/8;
end
next_values=coord+delta_t*[v*cos(coord(3));
                            v*sin(coord(3));
                            v*tan(phi)/L];
 output1=next_values;
 output4=phi;
end

