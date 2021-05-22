function [stop,k,timer2]=stop_the_car(coord_ref,coord,stop_duration,k,stop,h,timer2,v)
x=coord(1); y=coord(2); time_over=false;
x_ref=coord_ref(1); y_ref=coord_ref(2);
(x-x_ref)^2+(y-y_ref)^2;
    if  (x-x_ref)^2+(y-y_ref)^2<sqrt(1.75)^2||v<10^(-3) %if we are close to this reference point
        
            timer2=timer2+h;
            if mod(timer2,stop_duration)==0
                time_over=true;
                timer2=0;
            end
            if time_over==true %else the stop time is over
                k=k+1; %we take the next reference point in order to start again
                stop=false; %we are not in stop mode anymore
                time_over=false;
            end
        
    else %else we are not close to the stop point
        k=k; %we keep this stop point as reference
        stop=true; %we stay in stop mode
        timer2=timer2;
    end
end

function my_callback_fcn_2(src, event)
set(src,'UserData',true);
end