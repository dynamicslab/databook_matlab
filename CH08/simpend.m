clear all, close all, clc

m = 1;
M = 5;
L = 2;
g = -10;
d = 1;

tspan = 0:.1:10;
y0 = [0; 0; pi; .5];
[t,y] = ode45(@(t,y)pendcart(y,m,M,L,g,d,0),tspan,y0);

for k=1:length(t)
    drawpend(y(k,:),m,M,L);
end

% function dy = pendcart(y,m,M,L,g,d,u)