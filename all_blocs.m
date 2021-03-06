function [outputArg] = all_blocs2
%ALL_BLOCS Get the totallity of the points for a unique trajectory, 
% Simulate the configuration of the car to go on this trajectory.

    delete(timerfindall);
    clear all;

    %Initialisation of the trajectory
    [coord_ref,Event]=get_trajectory;
    p=length(coord_ref);
    figure(1);
    plot(coord_ref(1,:),coord_ref(2,:),'b.');
    hold on;
    
    time=0;
    chrono=0;
    total_e=0;
    h=0.5;    
    phi=0;
    global k v ws a;
    k=2;
    v=0;
    ws=0;
    a=0;as=0;
    coord=[coord_ref(1,1);coord_ref(2,1);coord_ref(3,1)];%(x;y;theta)
    coord_deltat=[coord_ref(1,1);coord_ref(2,1);coord_ref(3,1)];%(x_deltat,y_deltat,theta_deltat);
    mem=[coord(1);coord(2);coord(3);v;ws;a;as];%(x;y;theta;v;ws;a;as)
    plot(coord_ref(1,k),coord_ref(2,k),'ko');
    hold on;    
    global stop timer2 finished counter stop_duration;
    stop=false;
    timer2=0;
    finished=false;
    counter=0;
    stop_duration=0;
    state='starting';
    e_budget=5000000;
    global e_spent;
    e_spent=0;
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
                case 'starting'
                    low_control(h,e_budget,p-k+1,coord_ref(:,k),coord_deltat,coord);
                    [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture ? l'instant t+h  
                    if mod(time,0.5)==0
                       [coord_deltat]=simulator(coord,v,ws,2*h,phi);
                       [k]=next_step(coord_deltat,coord_ref,k,p,Event,time);% compute the index of coord of the next step
                       plot(coord_ref(1,k),coord_ref(2,k),'ko');
                    end 
                    if v>0
                        state='running';
                    end
                case 'running'
                    low_control(h,e_budget,p-k+1,coord_ref(:,k),coord_deltat,coord);
                    [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture ? l'instant t+h  
                    if mod(time,0.5)==0
                       [coord_deltat]=simulator(coord,v,ws,2*h,phi);
                       [k]=next_step(coord_deltat,coord_ref,k,p,Event,time);% compute the index of coord of the next step
                       plot(coord_ref(1,k),coord_ref(2,k),'ko');
                    end 
                    if k==p 
                        stop=true;
                    end
                    if stop==true
                        state='stopping'; 
                        disp('state stop at'); disp(time);
                        disp('e spent');disp(e_spent);
                    end
                case 'stopping'
                    stop_the_car(coord_ref(:,k),coord,p,h,time,Event);
                    plot(coord_ref(1,k),coord_ref(2,k),'ko');
                    if stop==false
                        state='starting';
                    end
                    if stop==true                        
                        low_control(h,e_budget,p-k+1,coord_ref(:,k),coord_deltat,coord);
                        [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture ? l'instant t+h
                        [coord_deltat]=simulator(coord,v,ws,8*h,phi); %Calcule la conf de la voiture ? t+h+2
                    end

                    if v<=10^(-1) && k==p  %"distance entre pos actuelle et pos ref est petite"
                            disp('Finished');
                            finished=true;
                    end
            end
            time=time+h;
            chrono=[chrono,time];
            total_e=[total_e,e_spent];
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
    plot(mem(5,:),'b+'); xlabel('Time s'); ylabel('Angular speed (rad/s)');
    subplot(312);
    plot(chrono,mem(4,:),'g+');
    xlabel('time'); ylabel('V(m/s)');
    subplot(313);
    plot(chrono,total_e,'r+');
    xlabel('time'); ylabel('Total energy (J)');
%     disp('Energy spent: '); 
%     disp(e_spent);
end

function my_callback_fcn(src, event)
set(src,'UserData',true);

end