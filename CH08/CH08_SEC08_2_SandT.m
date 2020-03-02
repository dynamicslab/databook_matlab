clear all, close all, clc

s = tf('s');

L = 1/(s);
S = 1/(1+L);
T = L/(1+L);

bode(L);
hold on
bode(S)
bode(T)
l1=legend('L','S','T');
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
% h = findobj(l1,'type','line');
% set(h,'linewidth',2);
grid on
set(gcf,'Position',[100 100 500 350])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_LST');