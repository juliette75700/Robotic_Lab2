function [output] = delta_energy(v_i,v_f,delta_t)
M=810;
P0=7355;
a=(v_i-v_f)/delta_t;
v=(v_i+v_f)/2;
output=(M*abs(a)*abs(v)+P0)*delta_t;
end
