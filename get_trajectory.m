%
% trajectory generation test using cubic splines and plot the vehicle 
% 
%
function [outputArg,Event]=get_trajectory
clear all
h = 0.0001;

%%%%%%%%%%%%%%%%%%%%%%%%
% dimensions of the car
%
car_length = 3.332;
car_width = 1.508;
car_wheelbase = 2.2;
car_length_out_wheelbase = car_length - car_wheelbase;
% assume that the length out-of-wheelbase is identical at front and back of
% the car
a1 = car_length_out_wheelbase / 2;
%  car polygon constructed ccw
car_polygon = [ -a1, -car_width/2;
                car_wheelbase + a1, -car_width/2;
                car_wheelbase + a1, car_width/2;
                -1, car_width/2 ];

%%%%%%%%%%%%%%%%%%%%%%%%
% define the reference trajectory
figure(1)
% clf

imshow(imread('ist_map_detail.png'));
hold on

x_scale = 0.18107;
disp(['xx scale factor ', num2str(x_scale), ' meters/pixel']);


y_scale = 0.21394;
disp(['yy scale factor ', num2str(y_scale), ' meters/pixel']);

disp('use the mouse to input the world frame origin');
% [xx_org, yy_org, button] = ginput(1);
xx_org = 235;
yy_org = 258;
disp(['world frame origin at image coordinates ', num2str(xx_org), ' ', num2str(yy_org)]);

% draw the car at 0,0,0,0 configuration
plot(car_polygon(:,1)/x_scale+xx_org, car_polygon(:,2)/y_scale+yy_org)


%%% starting of the trajectory generation reference stuff

disp('use the mouse to input via points for the reference trajectory');
disp('--button 1,2,3 and 4--(in this order) to enter the respectives events');
disp('--button 9-- to end the input');
button = 1;
k = 1;
% while button==1
%     [x(k),y(k),button] = ginput(1);
%     if button==1
%         plot(x(k),y(k),'r+')
%     else
%         x(k)=[];
%         y(k)=[];
%     end
%     k = k + 1;
% end

 x=[7.021964440589766e+02,7.173915871639202e+02,7.265086730268864e+02];
y=[6.500923677363394e+02,7.534193408499563e+02,8.658633998265391e+02];
k=5;
drawnow;
disp([ num2str(k-1), ' points to interpolate from '])


npt = length(x);      % number of via points, including initial and final
nvia = [0:1:npt-1];
csinterp_x = csapi(nvia,x);
csinterp_y = csapi(nvia,y);
time = [0:h:npt-1];
xx = fnval(csinterp_x, time);
yy = fnval(csinterp_y, time);
plot(xx,yy);

% draw the car at every 10 points of the trajectory
tp = length(xx);
sp = round(tp/22);
theta=[]; xxx=[]; yyy=[];
for k=1:sp:tp,
    if k+1<=tp
        theta_car = atan2(yy(k+1)-yy(k), xx(k+1)-xx(k));
    else
        theta_car = atan2(yy(k)-yy(k-1), xx(k)-xx(k-1));
    end
    for p=1:4,
        rot_car_polygon(p,:) = ([cos(theta_car), -sin(theta_car); sin(theta_car), cos(theta_car)]*car_polygon(p,:)')';
    end
    plot(rot_car_polygon(:,1)/x_scale+xx(k), rot_car_polygon(:,2)/y_scale+yy(k))
    theta=[theta,theta_car];
    xxx=[xxx,xx(k)]; yyy=[yyy,yy(k)];
end


%%Events
event_1_x=[];
event_1_y=[];
event_2_x=[];
event_2_y=[]; 
event_2_vlim=[];
event_3_x=[]; 
event_3_y=[]; 
event_3_time=[]; 
event_3_duration=[];
event_4_x=[]; 
event_4_y=[]; 
event_4_time=[]; 
event_4_duration=[];
i=1;
if button==49 %event 1 is selected
    button=1;
    while button==1
        [event_1_x(i),event_1_y(i),button] = ginput(1);
        if button==1
            index=dsearchn([xx' yy'],[event_1_x(i) event_1_y(i)]);
            plot(xx(index),yy(index),'ro')
            event_1_x(i)=xx(index);
            event_1_y(i)=yy(index);
            xx=[xx(1:index),xx(index),xx(index+1:end)];%change trejectory to stop the car
            yy=[yy(1:index),yy(index),yy(index+1:end)];
            disp('There is a stop trafic sign at the location: ')
            disp('x:')
            disp(event_1_x(i))
            disp('y:')
            disp(event_1_y(i))
        else
            event_1_x(i)=[];
            event_1_y(i)=[];
        end
        i = i + 1;
    end
end

i=1;
if button==50 %event 2 is selected
    button=1;
    while button==1
        [event_2_x(i),event_2_y(i),button] = ginput(1);
        if button==1
            index=dsearchn([xx' yy'],[event_2_x(i) event_2_y(i)])
            plot(xx(index),yy(index),'bh')
            event_2_x(i)=xx(index);
            event_2_y(i)=yy(index);
            disp('The speed limit on the traffic sign is [in km/h]:');
            event_2_vlim(i) = input(' ');
            disp('There is a speed limit traffic sign of')
            disp(event_2_vlim(i))
            disp('at the location ')
            disp('x:')
            disp(event_2_x(i))
            disp('y:')
            disp(event_2_y(i))
        else
            event_2_x(i)=[];
            event_2_y(i)=[];
        end
        i = i + 1;
    end
end

i=1;
if button==51 %event 3 is selected
    button=1;
    while button==1
        [event_3_x(i),event_3_y(i),button] = ginput(1);
        if button==1
            index=dsearchn([xx' yy'],[event_3_x(i) event_3_y(i)]);
            plot(xx(index),yy(index),'kv')
            disp('How many pedestrian will cross at this traffic sign ?');
            j = input(' ');
            k=1;
            disp('There are');
            disp(j)
            disp('pedesterian(s) crossing a pedesterian traffic sign at the location')
            disp('x:')
            disp(xx(index))
            disp('y:')
            disp(yy(index))
            disp('The crossing time and duration are following:')
            while k<=j
                event_3_x(k)=xx(index);
                event_3_y(k)=yy(index);
                event_3_time(k) = 100*rand; %the crossing time will be random between 0s and 100s
                event_3_duration(k) = normrnd(10,3);%the crossing duration will follow a normal distribution with mean 10 and variance 3
                if event_3_duration(k)<0
                    event_3_duration(k)=0;
                end
                disp('time:')
                disp(event_3_time(k))
                disp('duration:')
                disp(event_3_duration(k))
                k=k+1;
            end
        else
            event_3_x(i)=[];
            event_3_y(i)=[];
        end
        i = i + 1;
    end
end

i=1;
if button==52 %event  is selected
    button=1;
    while button==1
        [event_4_x(i),event_4_y(i),button] = ginput(1);
        if button==1
            index=dsearchn([xx' yy'],[event_4_x(i) event_4_y(i)])
            plot(xx(index),yy(index),'gv')
            event_4_x(i)=xx(index);
            event_4_y(i)=yy(index);
            disp('The pedestrian will cross the road at the time [in sec from the start of the journey]:');
            event_4_time(i) = input(' ');
            disp('The duration of the pedesterian crossing [in sec]:');
            event_4_duration(i) = input(' ');
            disp('There is a pedesterian crossing the road at the location');
            disp('x:')
            disp(xx(index))
            disp('y:')
            disp(yy(index))
            disp('The crossing time and duration are following:')
            disp('time:')
            disp(event_4_time(i))
            disp('duration:')
            disp(event_4_duration(i))
        else
            event_4_x(i)=[];
            event_4_y(i)=[];
        end
        
        i = i + 1;
    end
end

Event.one=[event_1_x event_1_y];
Event.two=[event_2_x event_2_y event_2_vlim];
Event.three=[704.439883288324,359.247788944638,81.4723686393179,15.5016550437853];%[event_3_x event_3_y event_3_time event_3_duration];
Event.four=[710.703708516447,446.592693704846,10,10];%[event_4_x event_4_y event_4_time event_4_duration];
outputArg=[xxx;yyy;theta];
end

