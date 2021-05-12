function [stop,k]=stop_the_car(x_ref,y_ref,x,y,stop_duration,k)
    if  (x-x_ref)^2+(y-y_ref)^2<5^2 %if we are close to this reference point
        first_time=size(timerfind(my_timer_2));
        if first_time==[0 0] %we have to start the stop time
            my_timer_2 = timer('Name', 'my_timer', 'ExecutionMode', 'fixedRate', 'Period', stop_duration, ...
                        'StartFcn', @(x,y)disp('started...'), ...
                        'StopFcn', @(x,y)disp('stopped ...'), ...
                        'TimerFcn', @my_callback_fcn_2)                
            start(my_timer_2)
            my_timer_2.UserData=false; 
        end
        time_over=my_timer_2.UserData; %time_over is the boolean to see if the stop time is over
        if time_over==false %if the stop time is not over yet
            k=k-1;%we keep the same reference point
            stop=true;%we stay in stop mode
        else %else the stop time is over
            k=k; %we take the next reference point in order to start again
            stop=false; %we are not in stop mode
            delete(my_timer_2); %we delete the timer used for the stop
        end
    else %else we are not close to the stop point
        k=k-1; %we keep this stop point as reference
        stop=true; %we stay in stop mode
    end
end