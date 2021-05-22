function [index_next_step,stop,stop_duration,finished] = next_stepun(coord,coord_ref,k,p,stop)
    z=[coord_ref(1,k-1) coord_ref(1,k)];
    w=[coord_ref(2,k-1) coord_ref(2,k)];
    
    i=dsearchn([z' w'],[coord(1) coord(2)]);
    
    if stop==false
        if i==1
            index=k;
        else
            index=k+1;
        end
    else
        index=k;
    end
   
    
    traj_x=coord_ref(1,:)';
    traj_y=coord_ref(2,:)';
    a=size(traj_x);
    finished=false;
    
    
    %Event1
    stop_duration_1=0; 
    if k<p-1
        if (traj_x(index,1)==traj_x(index+1,1))&&(traj_y(index,1)==traj_y(index+1,1)) %if two point_ref are the same
            stop=true; %it means the car as to stop (Event 1)
            stop_duration_1=5; %to define 
            index=index+1;
        end
    end
    
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
    
    index_next_step=index;
    stop_duration=stop_duration_1;%max(stop_duration_1,stop_duration_3,stop_duration_4);
end