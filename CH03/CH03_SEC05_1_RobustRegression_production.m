% Compressed Sensing Examples
% 
% Copyright 2016, All Rights Reserved
% Code by Steven L. Brunton (sbrunton@uw.edu)

% Download and install CVX to run this example: http://cvxr.com/cvx/download/

clear all, close all, clc

x = sort(4*(rand(25,1)-.5)); % Random data from [-2,2]
b = .9*x + .1*randn(size(x)); % Line y=.9x with noise 
atrue = x\b;          % Least-squares slope (no outliers)

b(end) = -5.5;                  % Introduce outlier                 
acorrupt = x\b;                 % New slope

cvx_begin;
    variable aL1;     % aL1 is slope to be optimized 
    minimize( norm(aL1*x-b,1) ); % minimize L1 error
cvx_end;

hold on
scatter(x(1:end-1),b(1:end-1),'ko','MarkerFaceColor','b') % Data
scatter(x(end),b(end),'ko','MarkerFaceColor','r')      % Outlier
xgrid = -2:.01:2;
plot(xgrid,xgrid*atrue,'k--','LineWidth',1.5)  % L2 fit (no outlier)
plot(xgrid,xgrid*acorrupt,'r--','LineWidth',1.2)  % L2 fit (outlier)
plot(xgrid,xgrid*aL1,'b--','LineWidth',1.2)       % L1 fit
axis([-2 2 -6 2])

%%
set(gcf,'Position',[100 100 600 400])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/f_chCS_robustregression');