clear all, close all, clc

s = tf('s');

G = (s+1)/(s-2);
Gtrue = (s+.9)/(s-1.9);

K = 1/G;

L = K*Gtrue;

margin(L)

CL = feedback(L,1);
