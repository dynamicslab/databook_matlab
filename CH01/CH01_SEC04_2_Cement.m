clear all, close all, clc

load hald;  % Load Portlant Cement dataset
A = ingredients;
b = heat;

[U,S,V] = svd(A,'econ');
x = V*inv(S)*U'*b;                    % Solve Ax=b using the SVD

plot(b,'k','LineWidth',2);  hold on            % Plot data
plot(A*x,'r-o','LineWidth',1.,'MarkerSize',2); % Plot regression
l1 = legend('Heat data','Regression')

%% Alternative 1  (regress)
x = regress(b,A);

%% Alternative 2  (pinv)
x = pinv(A)*b;