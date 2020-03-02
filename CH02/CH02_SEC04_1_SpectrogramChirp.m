clear all, close all, clc

t = 0:0.001:2;
f0 = 50;
f1 = 250;
t1 = 2;
x = chirp(t,f0,t1,f1,'quadratic');
x = cos(2*pi*t.*(f0 + (f1-f0)*t.^2/(3*t1^2)));
% There is a typo in Matlab documentation... 
% ... divide by 3 so derivative amplitude matches frequency 

spectrogram(x,128,120,128,1e3,'yaxis')
colormap jet

set(gca,'LineWidth',1.2,'FontSize',12);
set(gcf,'Position',[100 100 550 200]);
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../../figures/SPECTROGRAM_CHIRP');

%%

