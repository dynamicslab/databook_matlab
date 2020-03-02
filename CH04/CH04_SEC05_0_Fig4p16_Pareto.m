clear all; close all; clc

x=0.2:0.1:5;
y=1./(x);

x2=0.2:0.1:5; n=length(x2);
y2=1./(x2) + 0.5*randn(1,n);

y3=y2+2*rand(5,1)+1


fill([0.5 1.4 1.4 0.5],[0.4 0.4 2 2],[0.8 0.8 0.8])
hold on

plot(x,y,'k','Linewidth',[2])
axis([0.2 4 0 5.5])
set(gca,'Xtick',[],'Ytick',[])

plot(x2,y3,'o','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0 1 0.2],'MarkerSize',8)
plot(x2,y2,'o','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0.9 0 1],'MarkerSize',8)
