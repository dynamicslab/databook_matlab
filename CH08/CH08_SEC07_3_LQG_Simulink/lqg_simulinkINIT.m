clear all, close all, clc

m = 1;
M = 5;
L = 2;
g = -10;
d = 1;

b = 1; % pendulum down (b=-1)

A = [0 1 0 0;
    0 -d/M b*m*g/M 0;
    0 0 0 1;
    0 -b*d/(M*L) -b*(m+M)*g/(M*L) 0];
B = [0; 1/M; 0; b*1/(M*L)];


C = [1 0 0 0];    % measure cart position, x

D = zeros(size(C,1),size(B,2));

Q = [1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1];
R = .0001;
K = lqr(A,B,Q,R);  % design controller u = -K*x

%  Augment system with disturbances and noise
Vd = .0000001*eye(4);  % disturbance covariance
Vn = .0000001;       % noise covariance

BF = [B Vd 0*B];  % augment inputs to include disturbance and noise

sysC = ss(A,BF,C,[0 0 0 0 0 Vn]);  % build big state space system... with single output

sysFullOutput = ss(A,BF,eye(4),zeros(4,size(BF,2)));  % system with full state output, disturbance, no noise

%  Build Kalman filter
[L,P,E] = lqe(A,Vd,C,Vd,Vn);  % design Kalman filter
Kf = (lqr(A',C',Vd,Vn))';   % alternatively, possible to design using "LQR" code

sysKF = ss(A-Kf*C,[B Kf],eye(4),0*[B Kf]);  % Kalman filter estimator
