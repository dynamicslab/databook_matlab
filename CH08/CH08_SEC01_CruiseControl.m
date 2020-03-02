clear all, close all, clc

t = 0:.01:10;        % time

wr = 60 + 0*t;       % reference speed
d = 10*sin(pi*t);    % disturbance

aModel = 1;          % y = aModel*u 
aTrue = .5;          % y = aTrue*u

uOL = wr/aModel;     % Open-loop u based on model
yOL = aTrue*uOL + d; % Open-loop response

K = 50;              % control gain, u=K(wr-y);
yCL = aTrue*K/(1+aTrue*K)*wr + d/(1+aTrue*K);

figure, hold on
plot(t,wr,'k','LineWidth',2)
plot(t,d,'k--','LineWidth',1.5)
plot(t,yOL,'r','LineWidth',1.5)
plot(t,yCL,'b','LineWidth',1.5)

xlabel('Time')
ylabel('Speed')
grid on, box on
set(gcf,'Position',[100 100 500 210])
l1=legend('Reference','Disturbance','Open Loop','Closed Loop');
set(l1,'Location','SouthEast')
ylim([-15 65])

set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/CruiseControl');