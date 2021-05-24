function [v_max] = speed_limiter(x,y,v_max,Event)
a=size(Event.two);
if a(1,1)~=0
    index=dsearchn([Event.two(:,1) Event.two(:,2)],[x y]);
    if  (x-Event.two(index,1))^2+(y-Event.two(index,2))^2<sqrt(20)^2  %if we passed the speed limitation panel
        v_max=Event.two(index,3);     
    end
end
      
end
