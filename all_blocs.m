function [outputArg] = all_blocs
%ALL_BLOCS Get the totallity of the points for a unique trajectory, 
% Simulate the configuration of the car to go on this trajectory.
%   Detailed explanation goes here

%Initialisation of the trajectory
    coord=get_trajectory;
    p=length(coord);
    p=length(coord);
    x_ref=coord(1,:);
    y_ref=coord(2,:);
    theta_ref=coord(3,:);
    p=length(coord);
    
    figure(1);
    plot(x_ref,y_ref,'b.');
    hold on;
    
    time=0;
    h=1;
    k=2;
    phi=0;
    v_lim=9;
    ws_lim=100;
    x=x_ref(1); y=y_ref(1); theta=theta_ref(1); v=0; ws=0;  %starting at same position as the ref
    x_deltat=x; y_deltat=y; theta_deltat=theta;
    x_mem=[x]; y_mem=[y]; theta_mem=[theta];
    v_mem=[0]; ws_mem=[0];
    a_mem=[0]; as_mem=[0];% for plots later
    
    while k<=p 
        x_a=x_ref(k);y_a=y_ref(k);
        time=time+h;
        [a,as]=control_bloc2(x_ref(k),y_ref(k),theta_ref(k),x_deltat,y_deltat,theta_deltat,x,y,theta,h+2);
        if v>=v_lim
            v=v_lim;
        else
            v=v+a*h;
        end
        if ws>=ws_lim
            ws=ws_lim;
        else
            ws=ws+as*h;
        end
        [x,y,theta,phi]=simulator(x,y,theta,v,ws,h,phi);
        [x_deltat,y_deltat,theta_deltat]=simulator(x,y,theta,v,ws,h+2,phi);
        v_mem=[v_mem;v];ws_mem=[ws_mem;ws];
        a_mem=[a_mem;a];as_mem=[as_mem;as];
        x_mem=[x_mem;x];y_mem=[y_mem;y];theta_mem=[theta_mem;theta];
        
        
        if mod(time,1)==0
            k=next_step(x_deltat,y_deltat,x_ref,y_ref);% compute the index of coord of the next step
        end

%         [v,ws]=control_bloc1(x_ref(k),y_ref(k),theta_ref(k),x,y,theta);
%         v_mem=[v_mem;v];ws_mem=[ws_mem;ws];
%         [x,y,theta]=simulator(x,y,theta,v,ws,h,phi);
%         x_mem=[x_mem;x];y_mem=[y_mem;y];theta_mem=[theta_mem;theta];
% 
%         time=time+h;
%         if mod(time,2)==0
%             k=next_step(x,y,x_ref,y_ref);% compute the index of coord of the next step
%         end

    end
    figure(1);
    plot(x_mem,y_mem,'g+');
    figure(2);
    plot(theta_mem,'b+'); xlabel('Time s'); ylabel('theta (rad)');
    figure(3);
    plot(v_mem,'g+');
    xlabel('time'); ylabel('V(m/s)');
%     hold on;
%     plot(ws_mem,'b*');
%     figure(4);
%     plot(a_mem,'r+'); ylabel('acceleration');
%     hold on;
%     plot(as_mem,'g+');
end


