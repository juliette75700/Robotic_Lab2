function [outputArg] = all_blocs
%ALL_BLOCS Get the totallity of the points for a unique trajectory, 
% Simulate the configuration of the car to go on this trajectory.
%   Detailed explanation goes here

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
    v_lim=9;
    ws_lim=100;
   
    x=x_ref(1); y=y_ref(1); theta=theta_ref(1); v=0; ws=0;  %starting at same position as the ref
    x_deltat=x; y_deltat=y; theta_deltat=theta;
    x_mem=[x]; y_mem=[y]; theta_mem=[theta]; v_mem=[0]; ws_mem=[0]; a_mem=[0]; as_mem=[0];% for plots later
    
    stop=false;
    finished=false;
    
    while k<=p 
        x_a=x_ref(k);y_a=y_ref(k);
        time=time+h;
         if k<p-1
        [a,as]=control_bloc2(x_ref(k),y_ref(k),theta_ref(k),x_deltat,y_deltat,theta_deltat,x,y,theta,h+3);
        %%Limitateur de vitess        
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
        [x,y,theta,phi]=simulator(x,y,theta,v,ws,h,phi); %Simule la voiture � l'instant t+h
        [x_deltat,y_deltat,theta_deltat]=simulator(x,y,theta,v,ws,h+3,phi); %Calcule la conf de la voiture � t+h+2
        
            [k,stop,stop_duration,finished]=next_step(x_deltat,y_deltat,x_ref,y_ref,Event);% compute the index of coord of the next step
        end
        
        if k==p-1
          [a,as]=control_bloc3(x_ref(k),y_ref(k),theta_ref(k),x_deltat,y_deltat,theta_deltat,x,y,theta,h+3);
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
          [x,y,theta,phi]=simulator(x,y,theta,v,ws,h,phi); %Simule la voiture � l'instant t+h
          [x_deltat,y_deltat,theta_deltat]=simulator(x,y,theta,v,ws,h+3,phi); %Calcule la conf de la voiture � t+h+2
          [k,stop,stop_duration,finished]=next_step(x_deltat,y_deltat,x_ref,y_ref,Event);% compute the index of coord of the next step
 
        end
        if k==p
          [a,as]=control_bloc3(x_ref(k),y_ref(k),theta_ref(k),x_deltat,y_deltat,theta_deltat,x,y,theta,h+3);
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
          [x,y,theta,phi]=simulator(x,y,theta,v,ws,h,phi); %Simule la voiture � l'instant t+h
          [x_deltat,y_deltat,theta_deltat]=simulator(x,y,theta,v,ws,h+3,phi); %Calcule la conf de la voiture � t+h+2
 
        end
        
        %%Save les coord pour les plots
        v_mem=[v_mem;v];ws_mem=[ws_mem;ws];
        a_mem=[a_mem;a];as_mem=[as_mem;as];
        x_mem=[x_mem;x];y_mem=[y_mem;y];theta_mem=[theta_mem;theta];
        
        
        %%Determine si la voiture est arr�t�e
        if finished||x==x_a
            k=k-1;
            if (x-x_ref(k))^2+(y-y_ref(k))^2<5^2 %"distance entre pos actuelle et pos ref est petite"
                display('finished')
                break;
            end
        end
         %%determine s'il faut arr�ter la voiture
        if stop || v<10^(-5)
            %[stop,k]=stop_the_car(x_ref(k),y_ref(k),x,y,stop_duration,k);
            display('THE CAR HAS STOPPED!');
            k
            break;
            
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
    subplot(211);
    plot(theta_mem,'b+'); xlabel('Time s'); ylabel('theta (rad)');
    subplot(212);
    plot(v_mem,'g+');
    xlabel('time'); ylabel('V(m/s)');
%     hold on;
%     plot(ws_mem,'b*');
%     figure(4);
%     plot(a_mem,'r+'); ylabel('acceleration');
%     hold on;
%     plot(as_mem,'g+');
end


