clear all; close all;

% The data
x=[1 2 3 4 5 6 7 8 9 10]
y=[0.2 0.5 0.3 3.5 1.0 1.5 1.8 2.0 2.3 2.2]

p1=fminsearch('fit1',[1 1],[],x,y);
p2=fminsearch('fit2',[1 1],[],x,y);
p3=fminsearch('fit3',[1 1],[],x,y);

xf=0:0.1:11
y1=polyval(p1,xf); y2=polyval(p2,xf); y3=polyval(p3,xf);

subplot(2,1,2)
plot(xf,y1,'k'), hold on
plot(xf,y2,'k--','Linewidth',[2])
plot(xf,y3,'k','Linewidth',[2])
plot(x,y,'ro','Linewidth',[2]), hold on

legend('E_\infty','E_1','E_2','location','NorthWest')
set(gca,'Fontsize',[15],'Ylim',[0 4],'Ytick',[0 1 2 3 4],'Xlim',[0 11],'Xtick',[0 2 4 6 8 10])

x=[1 2 3 4 5 6 7 8 9 10]
y=[0.2 0.5 0.3 0.7 1.0 1.5 1.8 2.0 2.3 2.2]

p1=fminsearch('fit1',[1 1],[],x,y);
p2=fminsearch('fit2',[1 1],[],x,y);
p3=fminsearch('fit3',[1 1],[],x,y);

xf=0:0.1:11
y1=polyval(p1,xf);
y2=polyval(p2,xf);
y3=polyval(p3,xf);

subplot(2,1,1)
plot(xf,y1,'k'), hold on
plot(xf,y2,'k--','Linewidth',[2])
plot(xf,y3,'k','Linewidth',[2])

plot(x,y,'ro','Linewidth',[2]), hold on

legend('E_\infty','E_1','E_2','location','NorthWest')
set(gca,'Fontsize',[15],'Ylim',[0 4],'Ytick',[0 1 2 3 4],'Xlim',[0 11],'Xtick',[0 2 4 6 8 10])
