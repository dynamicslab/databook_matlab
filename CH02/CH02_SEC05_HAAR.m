clear all, close all, clc

x = 0:.001:1;

n = length(x);
n2 = floor(n/2);
n4 = floor(n/4);

f10 = 0*x;
f10(1:n2-1) = 1;
f10(n2:end) = -1;

f21 = 0*x;
f21(1:n4-1) = 1;
f21(n4:n2-1) = -1;
f21 = f21*sqrt(2);

f22 = 0*x;
f22(n2:n2+n4-1) = 1;
f22(n2+n4:end) = -1;
f22 = f22*sqrt(2);

x = [-1 0 x 1 2];
f10 = [0 0 f10 0 0];
f21 = [0 0 f21 0 0];
f22 = [0 0 f22 0 0];

subplot(3,1,1)
plot(x,f10,'k','LineWidth',2)
xlim([-.2 1.2])
ylim([-1.2 1.2])
set(gca,'XTick',[0 .25 .5 .75 1])
set(gca,'LineWidth',1.2,'FontSize',12);
subplot(3,1,2)
plot(x,f21,'k','LineWidth',2)
xlim([-.2 1.2])
ylim([-1.75 1.75])
set(gca,'XTick',[0 .25 .5 .75 1])
set(gca,'LineWidth',1.2,'FontSize',12);
subplot(3,1,3)
plot(x,f22,'k','LineWidth',2)
xlim([-.2 1.2])
ylim([-1.75 1.75])
set(gca,'XTick',[0 .25 .5 .75 1])
set(gca,'LineWidth',1.2,'FontSize',12);
set(gcf,'Position',[100 100 550 350]);
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/HAAR');

%%
figure
x = -5:.001:5;

fMexHat = (1-x.^2).*exp(-x.^2/2);
plot(x,fMexHat,'k','LineWidth',2)