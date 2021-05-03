function [output]=demi_closed_loop(x_ref,y_ref,theta_ref)
%DEMI_CLOSED_LOOP Closed loop without the guidance block
%   Detailed explanation goes here
close all;
x=0; y=0; theta=0;
x_mem=[x]; y_mem=[y]; theta_mem=[theta]; v_mem=[0]; ws_mem=[0];
time=0;
for i=1:500
    
    u=control_block1(x_ref,y_ref,theta_ref,x,y,theta);
    v=u(1);
    ws=u(2);
    v_mem=[v_mem;v];
    ws_mem=[ws_mem;ws];
    C=simulator(x,y,theta,v,ws,1,time);
    x=C(1);
    y=C(2);
    theta=C(3);
    x_mem=[x_mem;x];
    y_mem=[y_mem;y];
    theta_mem=[theta_mem;theta];
    figure(1);
    plot(x_mem(i),y_mem(i),'r+'); xlabel('x'); ylabel('y');
    hold on;
    figure(2);
    plot(i, theta_mem(i),'b+'); xlabel('Time 0.01s'); ylabel('theta');
    hold on;
    figure(3);
    plot(i,v,'g+');
    hold on;
    plot(i,ws,'y*');xlabel('Time 0.01s'); ylabel('V,ws');
    hold on;
    
    time=time+i;
end

end


