clear all, close all, clc

s = tf('s');
% G = 1/(s*(s*s+s+1));
G = 1/(s+1);

[A,B,C,D] = tf2ss(G.num{1},G.den{1});
sys = ss(A,B,C,D);

Q = 1;
R = .001;

K = lqr(A,B,Q,R);

% compare with PID... integral reduces ss error, but requries ss control,
% so not optimal... 