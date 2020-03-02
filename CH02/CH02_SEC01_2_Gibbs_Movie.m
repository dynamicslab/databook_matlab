clear all, close all, clc

dx = 0.01;
L = 2*pi;
x = 0:dx:L;

f = zeros(size(x));% sin(x/L);%ones(size(x));
f(floor(length(f)/4):floor(3*length(f)/4)) = 1+f(floor(length(f)/4):floor(3*length(f)/4));
% f = (x-pi).^2;
fFS = zeros(size(x));

A0 = (1/pi)*sum(f.*ones(size(x)))*dx;
for m=1:100
    fFS = A0/2;
    for k=1:m
        Ak = (1/pi)*sum(f.*cos(2*pi*k*x/L))*dx;
        Bk = (1/pi)*sum(f.*sin(2*pi*k*x/L))*dx;
        fFS = fFS + Ak*cos(2*k*pi*x/L) + Bk*sin(2*k*pi*x/L);
    end
    
    plot(x,f,'k')
    hold on
    plot(x,fFS,'r-')
    
    pause(0.1)
end