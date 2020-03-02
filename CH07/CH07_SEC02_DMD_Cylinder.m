clear all, close all, clc
load ../DATA/VORTALL;
% VORTALL contains flow fields reshaped into column vectors
X = VORTALL;
[Phi, Lambda, b] = DMD(X(:,1:end-1),X(:,2:end),21);
% Code to plot the second mode 
fhandle = plotCylinder(real(reshape(Phi(:,2),199,449)));