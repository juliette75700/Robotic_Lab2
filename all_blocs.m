function [outputArg] = all_blocs2
%ALL_BLOCS Get the totallity of the points for a unique trajectory, 
% Simulate the configuration of the car to go on this trajectory.
%   Detailed explanation goes here
    delete(timerfindall);
    clear all;
    %close all;

    %Initialisation of the trajectory
    [coord_ref,Event]=get_trajectory;
    p=length(coord_ref);
    figure(1);
    plot(coord_ref(1,:),coord_ref(2,:),'b.');
    hold on;
    time=0;
    h=0.5;
    k=2;
    phi=0;
    v=0;
    ws=0;
    a=0;as=0;
    coord=[coord_ref(1,1);coord_ref(2,1);coord_ref(3,1)];%(x;y;theta)
    coord_deltat=[coord_ref(1,1);coord_ref(2,1);coord_ref(3,1)];%(x_deltat,y_deltat,theta_deltat);
    mem=[coord(1);coord(2);coord(3);v;ws;a;as];%(x;y;theta;v;ws;a;as)
    plot(coord_ref(1,k),coord_ref(2,k),'ko');
    hold on;
    stop=false;
    timer2=0;
    finished=false;
    state='running';
    v_max=9;
    my_timer = timer('Name', 'my_timer', 'ExecutionMode', 'fixedRate', 'Period', h, ...
                        'StartFcn', @(x,y)disp('timer started...'), ...
                        'StopFcn', @(x,y)disp('timer stopped ...'), ...
                        'TimerFcn', @my_callback_fcn);
    start(my_timer);
    my_timer.UserData=0; 
    while finished==false
        time_over=my_timer.UserData;
        if time_over==1           
            switch state
                case 'running'
                    [a,as]=control_bloc2(coord_ref(:,k),coord_deltat,coord,h);              
                    [v,ws]=lim_speed(v,ws,a,as,h,v_max);%Limitateur de vitesse 
                    [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture à l'instant t+h  
                    if mod(time,0.5)==0
                       [coord_deltat]=simulator(coord,v,ws,2*h,phi);
                       [k,stop,stop_duration,finished]=next_step(coord_deltat,coord_ref,k,p,stop);% compute the index of coord of the next step
                    end 
                    if k==p || v<10^(-5)
                        stop=true;
                    end
                    if stop==true
                        state='stopping';
                    end
                    plot(coord_ref(1,k),coord_ref(2,k),'ko');
                case 'stopping'
                    [stop,k,timer2]=stop_the_car(coord_ref(:,k),coord,stop_duration,k,stop,h,timer2,v);
                    if stop==false
                        state='running';

                    end
                    if stop==true
                        [a,as]=control_bloc3(coord_ref(:,k),coord_deltat,coord,h);
                        if a>0
                            [a,as]= control_bloc2(coord_ref(:,k),coord_deltat,coord,h);
                        end
                        [v,ws]=lim_speed(v,ws,a,as,h,v_max);
                        [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture à l'instant t+h
                        [coord_deltat]=simulator(coord,v,ws,2*h,phi); %Calcule la conf de la voiture à t+h+2
                    end

                    if v<=10^(-2) && k==p  %"distance entre pos actuelle et pos ref est petite"
                            display('finished');
                            finished=true;
                    end
            end
            time=time+h;
            mem_temp=[coord(1);coord(2);coord(3);v;ws;a;as];
            mem=[mem,mem_temp];
            time_over=0;
            my_timer.UserData=0;
            plot(coord(1),coord(2),'r+');
            drawnow;
        end
    end
    delete(my_timer);

    figure(1);
    plot(mem(1,:),mem(2,:),'r+');
    figure(2);
    subplot(311);
    plot(mem(3,:),'b+'); 
    hold on;
    plot(coord_ref(3,:),'r+');xlabel('Time s'); ylabel('theta (rad)');
    subplot(312);
    plot(mem(4,:),'g+');
    xlabel('time'); ylabel('V(m/s)');
    subplot(313);
    plot(mem(1,:),'r+');
    xlabel('time'); ylabel('x');
end

function [output1,output2]=lim_speed(v,ws,a,as,h,v_lim)
    
    if v+a*h>=v_lim 
         v=v_lim;
    else
        v=v+a*h;
    end
    output2=ws+as*h;
    output1=v;
end

function my_callback_fcn(src, event)
set(src,'UserData',true);

end