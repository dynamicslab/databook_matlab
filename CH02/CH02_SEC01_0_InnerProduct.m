clear all, close all, clc

f = [0 0 .1 .2  .25  .2 .25 .3 .35 .43 .45 .5 .55  .5 .4 .425 .45 .425 .4 .35 .3 .25 .225 .2 .1 0 0];
g = [0 0 .025 .1  .2  .175 .2 .25 .25 .3 .32 .35 .375  .325 .3 .275 .275 .25 .225 .225 .2 .175 .15 .15 .05 0 0] -0.025;

x = 0.1*(1:length(f));

xf = (.01:.01:x(end));
ff = interp1(x,f,xf,'cubic')

gf = interp1(x,g,xf,'cubic')


plot(xf(20:end-10),ff(20:end-10),'k','LineWidth',1.5)
hold on
plot(x(2:end-1),f(2:end-1),'bo','MarkerFace','b')
plot(xf(20:end-10),gf(20:end-10),'k','LineWidth',1.5)
plot(x(2:end-1),g(2:end-1),'ro','MarkerFace','r')


xlim([.1 2.7])
ylim([-.1 .6])
set(gca,'XTick',[.2:.1:2.6],'XTickLabels',{},'LineWidth',1.2)
set(gca,'YTick',[]);
box off

set(gcf,'Position',[100 100 550 250])

set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/InnerProduct');

% %%
% xc = x;
% fc = f;
% n = length(x);
% hold on
% fapx = 0*ff;
% dx = xc(2)-xc(1);
% L = xc(end)-xc(1);
% L = 2.5
% A0 = (1/pi)*sum(fc.*ones(size(xc)))*dx*L;
% fapx = fapx + A0/2;
% for k=1:10
%     Ak = (1/pi)*sum(fc.*cos(2*pi*k*xc/L))*dx*L;
%     Bk = (1/pi)*sum(fc.*sin(2*pi*k*xc/L))*dx*L;
% 
%     fapx = fapx + Ak*cos(2*k*pi*xf/L) + Bk*sin(2*k*pi*xf/L);
% end
%     plot(xf,fapx,'k')
