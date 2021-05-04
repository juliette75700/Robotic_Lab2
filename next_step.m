% xx=[0 1 2 2.5 3];
% yy=[0 1 2 2.5 3];
% x=1.1;
% y=1.1;
% 
% next_stepun(x,y,xx,yy)




function [output] = next_stepun(x,y,xx,yy)
    index=dsearchn([xx' yy'],[x y]);
    output=index;
end

