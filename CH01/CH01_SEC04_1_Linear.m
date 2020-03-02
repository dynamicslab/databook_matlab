clear all, close all, clc

x = 3;                                  % True slope
a = [-2:.25:2]';
b = a*x + 1*randn(size(a));             % Add noise
plot(a,x*a,'k','LineWidth',1.5)         % True relationship
hold on
plot(a,b,'rx','LineWidth',1.5)          % Noisy measurements

[U,S,V] = svd(a,'econ');
xtilde = V*inv(S)*U'*b;                  % Least-square fit

plot(a,xtilde*a,'b--','LineWidth',1.5)   % Plot fit
l1=legend('True line','Noisy data','Regression line');

set(l1,'String',{'                             ','',''})
set(l1,'Location','NorthWest')
grid on     
set(gcf,'Position',[100 100 300 300])
set(gcf,'PaperPositionMode','auto')
set(gca,'FontSize',13)
print('-depsc2', '-loose', 'figures/CH01_EX_PseudoInv')

%% Three methods of computing regression
xtilde1 = V*inv(S)*U'*b
xtilde2 = pinv(a)*b
xtilde3 = regress(b,a)


