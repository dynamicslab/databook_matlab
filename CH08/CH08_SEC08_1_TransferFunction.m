clear all, close all, clc

s = tf('s')
G = 1/(s^2 + s + 2);

bode(G)
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
grid on
set(gcf,'Position',[100 100 500 300])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_Bode');



A = [0 1; -2 -1];
B = [0; 1];
C = [1 0];
D = 0;

[num,den] = ss2tf(A,B,C,D);
G = tf(num,den)

impulse(G)
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
grid on
set(gcf,'Position',[100 100 500 250])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_Impulse');
step(G)
h = findobj(gcf,'type','line');
set(h,'linewidth',2);
grid on
set(gcf,'Position',[100 100 500 250])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_Step');
