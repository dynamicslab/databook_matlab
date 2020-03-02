clear all, close all, clc

n = 1000;
q = n/4;
X = zeros(n,n);
X(q:(n/2)+q,q:(n/2)+q) = 1;

subplot(2,2,1), imshow(X); colormap gray, axis off

Y = imrotate(X,10,'bicubic');  % rotate 10 degrees
Y = Y - Y(1,1);
nY = size(Y,1);
startind = floor((nY-n)/2);
Xrot = Y(startind:startind+n-1, startind:startind+n-1);
subplot(2,2,2), imshow(Xrot); colormap gray, axis off

[U,S,V] = svd(X);  % svd well-aligned square
[U,S,V] = svd(Xrot);  % svd rotated square

subplot(2,2,3), semilogy(diag(S),'-ko')
ylim([1.e-16 1.e4]), grid on
set(gca,'YTick',[1.e-16 1.e-12 1.e-8 1.e-4 1. 1.e4])
set(gca,'XTick',[0 250 500 750 1000])

subplot(2,2,4), semilogy(diag(S),'-ko')
ylim([1.e-16 1.e4]), grid on
set(gca,'YTick',[1.e-16 1.e-12 1.e-8 1.e-4 1. 1.e4])
set(gca,'XTick',[0 250 500 750 1000])