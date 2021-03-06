function stop_the_car(coord_ref,coord,p,h,time,Event)
x=coord(1); y=coord(2); time_over=false; 
global timer2 stop counter v stop_duration k;
x_ref=coord_ref(1); y_ref=coord_ref(2);
(x-x_ref)^2+(y-y_ref)^2;
if (x-x_ref)^2+(y-y_ref)^2<sqrt(5)^2||v<10^(-1) %if we are close to this reference point
     if counter==0
        if k==p
            stop_duration_1=20; %to define 
        else
            stop_duration_1=4;
        end
        stop_duration_3=[];
        a=size(Event.three);
        if a(1,1)~=0
            th=size(Event.three(:,1));
            for i=1:th(1,2)
                stop_duration_3=[stop_duration_3,Event.three(i,3)+Event.three(i,4)-time];
            end
        end
        stop_duration_3=max(stop_duration_3);
        stop_duration_4=[];
        a=size(Event.four);
        if a(1,1)~=0
            fo=size(Event.four(:,1));
            for i=1:fo(1,2)
                stop_duration_4=[stop_duration_4 Event.four(i,3)+Event.four(i,4)-time];
            end
        end
        stop_duration_4=max(stop_duration_4); 
        stop_duration=[stop_duration_1 stop_duration_3 stop_duration_4];
        stop_duration=max(stop_duration);
        counter=1;
    end
    timer2=timer2+h;
    if mod(timer2,4)==0
        time_over=true;
        timer2=0;
    end
    if time_over==true %else the stop time is over
        k=k+1; %we take the next reference point in order to start again
        stop=false; %we are not in stop mode anymore
        counter=0;
    end
else %else we are not close to the stop point
    k=k; %we keep this stop point as reference
    %we stay in stop mode
end
end

function my_callback_fcn_2(src, event)
set(src,'UserData',true);
end