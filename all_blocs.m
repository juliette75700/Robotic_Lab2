function [outputArg] = all_blocs
%ALL_BLOCS Get the totallity of the points for a unique trajectory, 
% Simulate the configuration of the car to go on this trajectory.
%   Detailed explanation goes here
delete(timerfindall);
clear all;
close all;

%Initialisation of the trajectory
    [coord,Event]=get_trajectory;
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
   
    x=x_ref(1); y=y_ref(1); theta=theta_ref(1); v=0; ws=0;  %starting at same position as the ref
    x_deltat=x; y_deltat=y; theta_deltat=theta;
    x_mem=[x]; y_mem=[y]; theta_mem=[theta]; v_mem=[0]; ws_mem=[0]; a_mem=[0]; as_mem=[0];% for plots later
    
    stop=false;
    timer2_exist=0;
    finished=false;
    
    
    while k<=p 
        [k,stop,stop_duration,finished]=next_step(x,y,x_ref,y_ref,k,p,stop);% compute the index of coord of the next step

        x_a=x_ref(k);y_a=y_ref(k);
        time=time+h;
        [a,as]=control_bloc2(x_ref(k),y_ref(k),theta_ref(k),x_deltat,y_deltat,theta_deltat,x,y,theta,h+1);
              
        [v,ws]=lim_speed(v,ws,a,as,h);%Limitateur de vitesse 
        
        [x,y,theta,phi]=simulator(x,y,theta,v,ws,h,phi); %Simule la voiture à l'instant t+h
        [x_deltat,y_deltat,theta_deltat]=simulator(x,y,theta,v,ws,h+1,phi); %Calcule la conf de la voiture à t+h+1
        
        
%         plot(x_ref(k),y_ref(k),'ko');
         
         
        %%Save les coord pour les plots
        v_mem=[v_mem;v];ws_mem=[ws_mem;ws];a_mem=[a_mem;a];as_mem=[as_mem;as];
        x_mem=[x_mem;x];y_mem=[y_mem;y];theta_mem=[theta_mem;theta];
        figure(1);
        plot(x_mem,y_mem,'r+');
        
        %Determine si la voiture est arrêtée
        if k==p
            stop=true;
            finished=true;
        end
        
        while stop %S'arrete si k=p ou si Event1
            [stop,k,timer2_exist]=stop_the_car(x_ref(k),y_ref(k),x,y,stop_duration,k,timer2_exist);
            [a,as]=control_bloc3(x_ref(k),y_ref(k),theta_ref(k),x_deltat,y_deltat,theta_deltat,x,y,theta,h+2);
            %%Limitateur de vitess        
            [v,ws]=lim_speed(v,ws,a,as,h);
            [x,y,theta,phi]=simulator(x,y,theta,v,ws,h,phi); %Simule la voiture à l'instant t+h
            [x_deltat,y_deltat,theta_deltat]=simulator(x,y,theta,v,ws,h+2,phi); %Calcule la conf de la voiture à t+h+2
            if ((x-x_ref(k))^2+(y-y_ref(k))^2<2^2 || v<0) && finished   %"distance entre pos actuelle et pos ref est petite"
                    display('finished');
                    k=k+1;
                    break;
            end
            v_mem=[v_mem;v];ws_mem=[ws_mem;ws];a_mem=[a_mem;a];as_mem=[as_mem;as];
            x_mem=[x_mem;x];y_mem=[y_mem;y];theta_mem=[theta_mem;theta];
             figure(1);
             plot(x_mem,y_mem,'r+');
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
    plot(x_mem,y_mem,'r+');
    figure(2);
    subplot(311);
    plot(theta_mem,'b+'); xlabel('Time s'); ylabel('theta (rad)');
    subplot(312);
    plot(v_mem,'g+');
    xlabel('time'); ylabel('V(m/s)');
    subplot(313);
    plot(x_mem,'r+');
    xlabel('time'); ylabel('x');
%     hold on;
%     plot(ws_mem,'b*');
%     figure(4);
%     plot(a_mem,'r+'); ylabel('acceleration');
%     hold on;
%     plot(as_mem,'g+');
end

function [output1,output2]=lim_speed(v,ws,a,as,h)
    v_lim=9;
    ws_lim=100;
    if v>=v_lim && a>0
                v=v_lim;
    else
        v=v+a*h;
    end
    if ws>=ws_lim
        ws=ws_lim;
    else
        ws=ws+as*h;
    end
    output1=v;
    output2=ws;
end