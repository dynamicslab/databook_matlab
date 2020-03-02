clear all, close all, clc

m = 1;
M = 5;
L = 2;
g = -10;
d = 1;

s = -1; % pendulum up (s=1)

A = [0 1 0 0;
    0 -d/M -m*g/M 0;
    0 0 0 1;
    0 -s*d/(M*L) -s*(m+M)*g/(M*L) 0];

B = [0; 1/M; 0; s*1/(M*L)];

C = [0 0 1 0];  % only observable if x measured... because x can't be
% reconstructed
% C = [0 1 0 0];
obsv(A,C)
det(obsv(A,C))

%%  Which measurements are best if we omit "x" 
A = [0 1 0 0;
    0 -d/M -m*g/M 0;
    0 0 0 1;
    0 -s*d/(M*L) -s*(m+M)*g/(M*L) 0];
B = [0; 1/M; 0; s*1/(M*L)];
A = A(2:end,2:end);
B = B(2:end);
C = [1 0 0];
C = [0 1 0];
% C = [0 0 1];
obsv(A,C)

D = zeros(size(C,1),size(B,2));
sys = ss(A,B,C,D);
det(gram(sys,'o'))