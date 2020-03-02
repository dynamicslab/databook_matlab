clear all, close all, clc

dx = 0.01;
L = 10;
x = 0:dx:L;

f = zeros(size(x)); 
f(floor(length(f)/4):floor(3*length(f)/4)) = 1;%+f(floor(length(f)/4):floor(3*length(f)/4));
% fFS = zeros(size(x));

A0 = sum(f.*ones(size(x)))*dx*2/L;
for m=100%1:100
    fFS = A0/2;
    for k=1:m
        Ak = sum(f.*cos(2*pi*k*x/L))*dx*2/L;
        Bk = sum(f.*sin(2*pi*k*x/L))*dx*2/L;
        fFS = fFS + Ak*cos(2*k*pi*x/L) + Bk*sin(2*k*pi*x/L);
    end
    
    plot(x,f,'k','LineWidth',2)
    hold on
    plot(x,fFS,'r-','LineWidth',1.2)
    
    pause(0.1)
end

set(gca,'XTick',[],'XTickLabels',{},'LineWidth',1.2)
set(gca,'YTick',[]);
box off
% axis off

set(gcf,'Position',[100 100 550 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/Gibbs');