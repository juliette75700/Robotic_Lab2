function [index_next_step,stop,stop_duration,finished] = next_stepun(x,y,xx,yy,Event)
    index=dsearchn([xx' yy'],[x y]);
    traj_x=xx';
    traj_y=yy';
    a=size(traj_x);
    stop=false;
    finished=false;
    
    %end of the journey
    if index==a(1,1) %if the next point_ref is the last point of the traj
       finished=true; %it means the journey is finished
    end
    
%     %Event1
%     stop_duration_1=0; 
%     if (traj_x(index+1,1)==traj_x(index+2,1))&&(traj_y(index+1,1)==traj_y(index+2,1)) %if two point_ref are the same
%         stop=true; %it means the car as to stop (Event 1)
%         stop_duration_1=4; %to define 
%     end
%     
%     %Event3
%     stop_duration_3=0;
%     th=size(Event.three(:,1));
%     for i=1:th(1,2)
%         if traj_x(index+1,1)==Event.three(i,1) && traj_y(index+1,1)==Event.three(i,2) && time>=Event.three(i,3) && time<=Event.three(i,4)
%             stop=true;
%             stop_duration_3=Event.three(i,3)+Event.three(i,4)-time;
%         end
%     end
%     
%     %Event4
%     stop_duration_4=0;
%     th=size(Event.four(:,1));
%     for i=1:th(1,2)
%         if traj_x(index+1,1)==Event.four(i,1) && traj_y(index+1,1)==Event.four(i,2) && time>=Event.four(i,3) && time<=Event.three(i,4)
%             stop=true;
%             stop_duration_4=Event.four(i,3)+Event.four(i,4)-time;
%         end
%     end
    
    index_next_step=index+1;
    stop_duration=0;%max(stop_duration_1,stop_duration_3,stop_duration_4);
end
