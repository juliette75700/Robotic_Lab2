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
    h=0.5;
    k=2;
    phi=0;
    global v ws a;
    v=0;
    ws=0;
    a=0;as=0;
    coord=[coord_ref(1,1);coord_ref(2,1);coord_ref(3,1)];%(x;y;theta)
    coord_deltat=[coord_ref(1,1);coord_ref(2,1);coord_ref(3,1)];%(x_deltat,y_deltat,theta_deltat);
    mem=[coord(1);coord(2);coord(3);v;ws;a;as];%(x;y;theta;v;ws;a;as)
    plot(coord_ref(1,k),coord_ref(2,k),'ko');
    hold on;    
    global stop timer2 finished;
    stop=false;
    timer2=0;
    finished=false;
    state='starting';
    e_budget=500000;
    global e_spent;
    e_spent=0;
    my_timer = timer('Name', 'my_timer', 'ExecutionMode', 'fixedRate', 'Period', h, ...
                        'StartFcn', @(x,y)disp('timer started...'), ...
                        'StopFcn', @(x,y)disp('timer stopped ...'), ...
                        'TimerFcn', @my_callback_fcn);
    start(my_timer);
    my_timer.UserData=0; 
    while finished==false
%         time_over=my_timer.UserData;
%         if time_over==1           
            switch state
                case 'starting'
                    [v,ws]=low_control(h,e_budget,p-k+1,coord_ref(:,k),coord_deltat,coord);
                    [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture ? l'instant t+h  
                    if mod(time,0.5)==0
                       [coord_deltat]=simulator(coord,v,ws,2*h,phi);
                       [k,stop_duration]=next_step(coord_deltat,coord_ref,k,p);% compute the index of coord of the next step
                       plot(coord_ref(1,k),coord_ref(2,k),'ko');
                    end 
                    if v>0
                        state='running';
                    end
                case 'running'
                    [v,ws]=low_control(h,e_budget,p-k+1,coord_ref(:,k),coord_deltat,coord);
                    [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture ? l'instant t+h  
                    if mod(time,0.5)==0
                       [coord_deltat]=simulator(coord,v,ws,2*h,phi);
                       [k,stop_duration]=next_step(coord_deltat,coord_ref,k,p);% compute the index of coord of the next step
                       plot(coord_ref(1,k),coord_ref(2,k),'ko');
                    end 
                    if k==p || v<10^(-5)
                        stop=true;
                    end
                    if stop==true
                        state='stopping'; 
                        disp('state stop at'); disp(time);
                        disp('e spent');disp(e_spent);
                    end
                case 'stopping'
                    [k]=stop_the_car(coord_ref(:,k),coord,stop_duration,k,h,v);
                    plot(coord_ref(1,k),coord_ref(2,k),'ko');
                    if stop==false
                        state='starting';
                    end
                    if stop==true                        
                        [v,ws]=low_control(h,e_budget,p-k+1,coord_ref(:,k),coord_deltat,coord);
                        [coord,phi]=simulator(coord,v,ws,h,phi); %Simule la voiture ? l'instant t+h
                        [coord_deltat]=simulator(coord,v,ws,7*h,phi); %Calcule la conf de la voiture ? t+h+2
                    end

                    if v<=10^(-1) && k==p  %"distance entre pos actuelle et pos ref est petite"
                            disp('finished');
                            finished=true;
                    end
            end
            time=time+h;
            chrono=[chrono,time];
            mem_temp=[coord(1);coord(2);coord(3);v;ws;a;as];
            mem=[mem,mem_temp];
            time_over=0;
            my_timer.UserData=0;
%             plot(coord(1),coord(2),'r+');
%             drawnow;
        end
%     end
%     delete(my_timer);

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
%     subplot(313);
%     plot(abs(mem(6,:)),'r+');
%     xlabel('time'); ylabel('a');
    disp('Energy spent: '); 
    disp(e_spent);
end

function my_callback_fcn(src, event)
set(src,'UserData',true);

end