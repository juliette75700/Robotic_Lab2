function [output] = events_interface()
i=1;
if button==97
    button=1;
    while button==1
        [event_1_x(i),event_1_y(i),button] = ginput(1);
        if button==1
            index=dsearchn([xx' yy'],[event_1_x(i) event_1_y(i)])
            plot(xx(index),yy(index),'ro')
            event_1_x(i)=xx(index);
            event_1_y(i)=yy(index);
        else
            event_1_x(i)=[];
            event_1_y(i)=[];
        end
        i = i + 1;
    end
end

i=1;
if button==98
    button=1;
    while button==1
        [event_2_x(i),event_2_y(i),button] = ginput(1);
        if button==1
            index=dsearchn([xx' yy'],[event_2_x(i) event_2_y(i)])
            plot(xx(index),yy(index),'bh')
            event_2_x(i)=xx(index);
            event_2_y(i)=yy(index);
        else
            event_2_x(i)=[];
            event_2_y(i)=[];
        end
        i = i + 1;
    end
end

i=1;
if button==99
    button=1;
    while button==1
        [event_3_x(i),event_3_y(i),button] = ginput(1);
        if button==1
            index=dsearchn([xx' yy'],[event_3_x(i) event_3_y(i)])
            plot(xx(index),yy(index),'gv')
            event_3_x(i)=xx(index);
            event_3_y(i)=yy(index);
            disp('The pedestrian will cross the road at the time [in sec from the start odf the journey]:');
            event_3_time(i) = input(' ');
            disp('The duration of the pedesterian crossing [in sec]:');
            event_3_duration(i) = input(' ');
        else
            event_3_x(i)=[];
            event_3_y(i)=[];
        end
        i = i + 1;
    end
end


end