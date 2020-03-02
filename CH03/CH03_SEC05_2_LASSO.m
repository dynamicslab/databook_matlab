clear all, close all, clc

A = randn(100,10);                   % Matrix of possible predictors
x = [0; 0; 1; 0; 0; 0; -1; 0; 0; 0]; % Two nonzero predictors
b = A*x + 2*randn(100,1);            % Observations (with noise)

xL2 = pinv(A)*b

[XL1 FitInfo] = lasso(A,b,'CV',10);
lassoPlot(XL1,FitInfo,'PlotType','CV')
lassoPlot(XL1,FitInfo,'PlotType','Lambda')

xL1 = XL1(:,FitInfo.Index1SE)
xL1DeBiased = pinv(A(:,abs(xL1)>0))*b



%%

figure(1)
set(gcf,'Position',[100 100 600 400])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/f_chCS_ex07_lassoA');

figure(2)
set(gcf,'Position',[100 100 600 400])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/f_chCS_ex07_lassoB');
