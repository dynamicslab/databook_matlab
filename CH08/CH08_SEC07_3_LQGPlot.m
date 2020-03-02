% clear all, close all, clc

CC = [0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

figure
plot(yn.Time,yn.Data(:,2),'Color',[.5 .5 .5])
hold on
plot(x.Time,x.Data(:,1),'Color',[0 0 0],'LineWidth',2)
plot(yKF.Time,yKF.Data(:,1),'--','Color',CC(1,:),'LineWidth',2)
set(gcf,'Position',[100 100 500 200])
xlabel('Time')
ylabel('Measurement')
l1 = legend('y (measured)','y (no noise)','y (KF estimate)');
set(l1,'Location','SouthEast')
grid on
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', 'figures/FIG_04b_KFmeas');

%%
subplot(2,1,1)
plot(wd.Time(1:100:end),wd.Data(1:100:end,1),'LineWidth',1.2)
xlim([45 50])
ylabel('Disturbance, d')
subplot(2,1,2)
plot(yn.Time(1:100:end),yn.Data(1:100:end,1),'LineWidth',1.2)
xlim([45 50])
set(gcf,'Position',[100 100 500 200])
xlabel('Time')
ylabel('Actuation, u')
grid on
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_04_LQGdist');

%%
plot(x.Time,x.Data,'LineWidth',2)
l1 = legend('x','v','\theta','\omega')
set(gcf,'Position',[100 100 500 200])
xlabel('Time')
ylabel('State')
grid on
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_02_LQGnew');
