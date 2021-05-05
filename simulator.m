function [output1,output2,output3] = simulator(x,y,theta,v,ws,delta_t,t)
%Located in the navigator function
%Take as inputs the actual (at t) variables of the position,
%orientation, and speed.
%Give as outputs the position and orientation at instant t+delta_t
L=2.2;
phi=ws*t;
if phi>pi/8
    phi=pi/8;
end 
if phi<-pi/8
    phi=-pi/8;
end
next_values=[x;y;theta]+delta_t*[v*cos(theta);
                            v*sin(theta);
                            v*tan(phi)/L];
 output1=next_values(1);
 output2=next_values(2);
 output3=next_values(3);
end

