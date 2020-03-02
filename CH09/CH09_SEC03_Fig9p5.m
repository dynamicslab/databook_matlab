clear all, close all, clc

%% Figure 1 - simple impulse response
% sys = drss(10,1,1);
load testSys_Fig9p5
t = 0:1:100;
[y,t]=impulse(sys,t);

t = [(-10:1:-1)'; t];
y = [zeros(10,1); y];
u = y*0;
u(11) = 1;

figure
subplot(2,1,1)
stairs(t,u,'k','LineWidth',1.5)
grid on
axis([-10 100 -.1 1.1])
set(gca,'Color','none')

subplot(2,1,2)
stairs(t,y,'k','LineWidth',1.5)
grid on
axis([-10 100 -.25 2.5])
set(gca,'Color','none')
set(gcf,'Position',[100 100 250 175])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/FIG_ERAOKID1');


%% Figure 2 - OKID response
t = 0:1:100;
u = 0*t;
u(1:50) = randn(50,1);
[y,t]=lsim(sys,u,t);

t = [(-10:1:-1)'; t];
y = [zeros(10,1); y];
u = [zeros(1,10) u];

figure
subplot(2,1,1)
stairs(t,u,'k','LineWidth',1.5)
set(gca,'Color','none')
axis([-10 100 min(u)-.5 max(u)+.5])
grid on

subplot(2,1,2)
stairs(t,y,'k','LineWidth',1.5)
axis([-10 100 min(y)-.5 max(y)+.5])
set(gca,'Color','none')
grid on
set(gcf,'Position',[100 100 250 175])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/FIG_ERAOKID2');