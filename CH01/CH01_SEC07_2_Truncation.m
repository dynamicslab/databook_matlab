clear all, close all, clc

n = 1000;    % 1000 x 1000 square
X = zeros(n,n);
X(n/4:3*n/4,n/4:3:n/4) = 1;
imshow(X);

Y = imrotate(X,10,'bicubic');  % rotate 10 degrees
Y = Y - Y(1,1);
nY = size(Y,1);
startind = floor((nY-n)/2);
Xrot = Y(startind:startind+n-1, startind:startind+n-1);
imshow(Xrot);
[U,S,V] = svd(X);     % SVD well-aligned square
[U,S,V] = svd(Xrot);  % SVD rotated square
semilogy(diag(S),'-ko')
semilogy(diag(S),'-ko')