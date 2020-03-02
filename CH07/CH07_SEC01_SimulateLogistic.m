clear all;
figure

xvals=[];
startval = 1;
endval = 4;
for r=startval:.00025:endval
    r
    x = 0.5;
    for i=1:10000
        x = logistic(x,r);
    end
    xss = x;  % steady state x
    for i=1:1000
        x = logistic(x,r);
        xvals(1,length(xvals)+1) = r;
        xvals(2,length(xvals)) = x;
        if(abs(x-xss)<.001)
            break
        end
    end
    
end
figure(1)
plot(xvals(2,:),xvals(1,:),'.','LineWidth',.1,'MarkerSize',1.2,'Color',[0 0 0])
axis([0 1 1 endval])
axis ij
figure(2)
plot(xvals(2,:),xvals(1,:),'.','LineWidth',.1,'MarkerSize',1.2,'Color',[0 0 0])
axis([0 1 3.45 4])
axis ij