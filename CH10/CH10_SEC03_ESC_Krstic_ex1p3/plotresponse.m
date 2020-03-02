clear all

s = tf('s');
Fi = (s-2)/(s^2+4*s+3);
Fo = 1/(s+2);

F = Fi*Fo;

t = 0:.001:100;
thetastar(:,1) = t;
thetastar(:,2) = .01 + .001*t;
fstar(:,1) = t;
fstar(:,2) = [(0:.001:10)*0 (10.001:.001:t(end))*0+.05];
%%
sim('NEWkrstic_example_1p3_wnoise',[0 t(end)]);

%%
figure
subplot(2,1,2)
plot(tout,y,'LineWidth',1.2);
hold on
plot(fstar(:,1),fstar(:,2),'LineWidth',1.2);
grid on
l1=legend('J','J^*');
set(l1,'Location','SouthEast')
% xlabel('Time (s)')
% ylabel('Output')
subplot(2,1,1)
plot(tout,theta,'LineWidth',1.2);
hold on
plot(thetastar(:,1),thetastar(:,2),'LineWidth',1.2);
grid on
l1=legend('\theta','\theta^*');
set(l1,'Location','SouthEast')


% xlabel('Time (s)')
% ylabel('Theta')
% 
% subplot(2,2,[2 4])
% bode(F)
set(gcf,'Position',[100 100 500 350])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../../../figures/ESC_ResponseHard');
