function [index_next_step] = next_step(coord,coord_ref,k,p,Event,time)
    z=[coord_ref(1,k-1) coord_ref(1,k)];
    w=[coord_ref(2,k-1) coord_ref(2,k)];
    global stop;
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
    
    
    %Event1
    stop_1=false; 
    if k<p-1
        if (traj_x(index,1)==traj_x(index+1,1))&&(traj_y(index,1)==traj_y(index+1,1)) %if two point_ref are the same
            stop_1=true; %it means the car as to stop (Event 1)            
            index=index+1;
        end
    end
    
    %Event3
    count=0;
    a=size(Event.three);
    if a(1,1)~=0
        th=size(Event.three(:,1));
        for i=1:th(1,2)
            if traj_x(index-1,1)==Event.three(i,1) && traj_y(index-1,1)==Event.three(i,2) && time>=Event.three(i,3) && time<Event.three(i,4)+Event.three(i,3)
                stop_3=true;
                count=1;
            end
        end
        if count==0
            stop_3=false;
        else
            index=index-1;
        end
    else
        stop_3=false;
    end
    
    %Event4
    count=0;
    a=size(Event.four);
    if a(1,1)~=0
        fo=size(Event.four(:,1));
        for i=1:fo(1,2)
            if traj_x(index-1,1)==Event.four(i,1) && traj_y(index-1,1)==Event.four(i,2) && time>=Event.four(i,3) && time<Event.four(i,4)+Event.four(i,3)
                stop_4=true;
                count=1;
            end
        end
        if count==0
            stop_4=false;
        else
            index=index-1;
        end
    else
        stop_4=false;
    end
        
    stop=stop_1||stop_3||stop_4;
    
        
    if coord_ref(1,index)==coord_ref(1,end) && coord_ref(2,index)==coord_ref(2,end)
        stop=true;
    end
    index_next_step=index;
end