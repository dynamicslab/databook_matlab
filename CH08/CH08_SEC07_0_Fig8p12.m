clear all, close all, clc


m = 1;
M = 5;
L = 2;
g = -10;
d = 1;
drawpend_FIG([0 0 pi-.3 0],m,M,L);
drawpend_FIG([0 0 pi-.3 0],m,M,L);
box off
hold on
axis off
plot([0 0],[.5 2.75],'k--','LineWidth',2)
axis([-2.5 2.5 -.5 3])
set(gcf,'Position',[100 100 400 275])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_01_Schematic');