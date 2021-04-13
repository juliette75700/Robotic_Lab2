function [output] = simulator(x,y,theta,phi,v,delta_t)
L=2.2;
output=[x;y;theta]+delta_t*[v*cos(theta);
                            v*sin(theta);
                            v*tan(phi)/L];
end
