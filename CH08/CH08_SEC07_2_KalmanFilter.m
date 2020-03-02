clear all, close all, clc

m = 1;
M = 5;
L = 2;
g = -10;
d = 1;

b = -1; % pendulum down (b=-1)

A = [0 1 0 0;
    0 -d/M b*m*g/M 0;
    0 0 0 1;
    0 -b*d/(M*L) -b*(m+M)*g/(M*L) 0];
B = [0; 1/M; 0; b*1/(M*L)];


C = [1 0 0 0];    % measure cart position, x
rank(obsv(A,C))
D = zeros(size(C,1),size(B,2));

%%  Specify disturbance and noise magnitude
Vd = eye(4);  % disturbance covariance
Vn = 1;       % noise covariance

%  Build Kalman filter
[Kf,P,E] = lqe(A,eye(4),C,Vd,Vn);  % design Kalman filter
% alternatively, possible to design using "LQR" code
Kf = (lqr(A',C',Vd,Vn))';   

%% Augment system with additional inputs
Baug = [B eye(4) 0*B];  % [u I*wd 0*wn]
Daug = [0 0 0 0 0 1];   % D matrix passes noise through

sysC = ss(A,Baug,C,Daug);  % single-measurement system 

% "true" system w/ full-state output, disturbance, no noise
sysTruth = ss(A,Baug,eye(4),zeros(4,size(Baug,2)));  

sysKF = ss(A-Kf*C,[B Kf],eye(4),0*[B Kf]);  % Kalman filter

%%  Estimate linearized system in "down" position (Gantry crane)
dt = .01;
t = dt:dt:50;

uDIST = sqrt(Vd)*randn(4,size(t,2)); % random disturbance
uNOISE = sqrt(Vn)*randn(size(t));    % random noise
u = 0*t;
u(1/dt) = 20/dt;    % positive impulse
u(15/dt) = -20/dt;  % negative impulse

uAUG = [u; uDIST; uNOISE];  % input w/ disturbance and noise

[y,t] = lsim(sysC,uAUG,t);         % noisy measurement
[xtrue,t] = lsim(sysTruth,uAUG,t); % true state
[xhat,t] = lsim(sysKF,[u; y'],t);  % state estimate

%% Plot signals 

CC = [0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

figure
plot(t,y,'Color',[.5 .5 .5])
hold on
plot(t,xtrue(:,1),'Color',[0 0 0],'LineWidth',2)
plot(t,xhat(:,1),'--','Color',CC(1,:),'LineWidth',2)
set(gcf,'Position',[100 100 500 300])
xlabel('Time')
ylabel('Measurement')
l1 = legend('y (measured)','y (no noise)','y (KF estimate)');
set(l1,'Location','NorthEast')
grid on
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_03b_KFmeas');

%
%

figure
for k=1:4
plot(t,xtrue(:,k),'-','LineWidth',1.2,'Color',CC(k,:));
hold on
plot(t,xhat(:,k),'--','LineWidth',2,'Color',CC(k,:))
end
set(gcf,'Position',[100 100 500 300])
xlabel('Time')
ylabel('State')
% l1 = legend('x','v','$\theta$','$\omega$','$\hat{x}$','$\hat{v}$','$\hat{\theta}$','$\hat{\omega}$');
l1 = legend('x','$\hat{x}$','v','$\hat{v}$','$\theta$','$\hat{\theta}$','$\omega$','$\hat{\omega}$');

set(l1,'Location','NorthEast','interpreter','latex')
grid on
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_03b_KFstate');