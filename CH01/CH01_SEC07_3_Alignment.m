clear all, close all, clc
n = 1000;
X = zeros(n,n);
X(n/4:3*n/4,n/4:3*n/4) = 1;
[U,S,V] = svd(X);
imagesc(X), hold on;
semilogy(diag(S),'-o','color',cm(1,:)), hold on, grid on

nAngles = 12;  % sweep through 12 angles, from 0:4:44
Xrot = X;
for j=2:nAngles
    Y = imrotate(X,(j-1)*4,'bicubic'); % rotate (j-1)*4
    startind = floor((size(Y,1)-n)/2);
    Xrot1 = Y(startind:startind+n-1, startind:startind+n-1);
    Xrot2 = Xrot1 - Xrot1(1,1);    
    Xrot2 = Xrot2/max(Xrot2(:));
    Xrot(Xrot2>.5) = j;
    
    [U,S,V] = svd(Xrot1);
    subplot(1,2,1), imagesc(Xrot), colormap([0 0 0; cm])    
    subplot(1,2,2), semilogy(diag(S),'-o','color',cm(j,:))       
end
