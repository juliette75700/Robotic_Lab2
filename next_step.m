xx=[0 1 2 2.5 3]
yy=[0 1 2 2.5 3]
x=1.6
y=1.6

next_stepun(x,y,xx,yy)


function [output] = next_stepun(x,y,xx,yy)
    index=dsearchn([xx' yy'],[x y]);
    output=[xx(index+1) yy(index+1)];
end

