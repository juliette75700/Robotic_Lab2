function [outputArg] = all_blocs
%ALL_BLOCS Get the totallity of the points for a unique trajectory, 
% Simulate the configuration of the car to go on this trajectory.
%   Detailed explanation goes here

%Initialisation of the trajectory
coord=get_trajectory;
x_ref=coord(1,:);
y_ref=coord(2,:);
map=figure(1);
plot(x_ref,y_ref,'b.');
hold on;
theta_ref=coord(3,:);
time=0;
h=0.01;
p=length(coord);
k=2;
x=x_ref(1); y=y_ref(1); theta=theta_ref(1); %starting at same position as the ref
x_mem=[x]; y_mem=[y]; theta_mem=[theta];v_mem=[0]; ws_mem=[0];% for plots later
while k<=p
    [v,ws]=control_bloc1(x_ref(k),y_ref(k),theta_ref(k),x,y,theta);
    
    v_mem=[v_mem;v];ws_mem=[ws_mem;ws];
    
    [x,y,theta]=simulator(x,y,theta,v,ws,1,time);
    
    x_mem=[x_mem;x];y_mem=[y_mem;y];theta_mem=[theta_mem;theta];
    time=time+h;
    k=next_step(x,y,x_ref,y_ref);% compute the index of coord of the next step

end
figure(1);
plot(x_mem,y_mem,'r+');
figure(2);
plot(theta_mem,'b+'); xlabel('Time 0.01s'); ylabel('theta');
figure(3);
plot(v_mem,'g+');
hold on;
plot(ws_mem,'y*');xlabel('Time 0.01s'); ylabel('V,ws');
end


