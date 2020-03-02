clear all, close all, clc

xC = [2; 1;];                           % Center of data (mean)
sig = [2; .5;];                         % Principal axes

theta = pi/3;                           % Rotate cloud by pi/3
R = [cos(theta) -sin(theta);            % Rotation matrix
    sin(theta) cos(theta)];

nPoints = 10000;                        % Create 10,000 points
X = R*diag(sig)*randn(2,nPoints) + diag(xC)*ones(2,nPoints); 

subplot(1,2,1)                          % Plot cloud of noisy data
scatter(X(1,:),X(2,:),'k.','LineWidth',2)
hold on, box on, grid on
axis([-6 8 -6 8])

%% f_ch01_ex03_1b

Xavg = mean(X,2);                       % Compute mean
B = X - Xavg*ones(1,nPoints);           % Mean-subtracted Data
[U,S,V] = svd(B/sqrt(nPoints),'econ');  % Find principal components (SVD)

subplot(1,2,2)
scatter(X(1,:),X(2,:),'k.','LineWidth',2)  % Plot data to overlay PCA
hold on, box on, grid on
axis([-6 8 -6 8])

theta = (0:.01:1)*2*pi;
[Xstd] = U*S*[cos(theta); sin(theta)];  % 1-std confidence interval
plot(Xavg(1)+Xstd(1,:),Xavg(2) + Xstd(2,:),'r-','LineWidth',1.5)
plot(Xavg(1)+2*Xstd(1,:),Xavg(2) + 2*Xstd(2,:),'r-','LineWidth',1.5)
plot(Xavg(1)+3*Xstd(1,:),Xavg(2) + 3*Xstd(2,:),'r-','LineWidth',1.5)

% Plot principal components U(:,1)S(1,1) and U(:,2)S(2,2)
plot([Xavg(1) Xavg(1)+U(1,1)*S(1,1)],[Xavg(2) Xavg(2)+U(2,1)*S(1,1)],'c-','LineWidth',2)
plot([Xavg(1) Xavg(1)+U(1,2)*S(2,2)],[Xavg(2) Xavg(2)+U(2,2)*S(2,2)],'c-','LineWidth',2)

set(gcf,'Position',[100 100 600 300])