clear all, close all, clc
n = 1000;
X = zeros(n,n);
X(n/4:3*n/4,n/4:3*n/4) = 1;
nAngles = 12;  % sweep through 12 different angles, from 0:4:44
cm=colormap(jet(nAngles));

[U,S,V] = svd(X);
subplot(1,2,1), imagesc(X), hold on;
subplot(1,2,2), semilogy(diag(S),'-o','color',cm(1,:)), hold on, grid on

Xrot = X;
for j=2:nAngles
    Y = imrotate(X,(j-1)*4,'bicubic');  % rotate  theta = (j-1)*4
    startind = floor((size(Y,1)-n)/2);
    Xrot1 = Y(startind:startind+n-1, startind:startind+n-1);
    Xrot2 = Xrot1 - Xrot1(1,1);    
    Xrot2 = Xrot2/max(Xrot2(:));
    Xrot(Xrot2>.5) = j;
    
    [U,S,V] = svd(Xrot1);
    subplot(1,2,1), imagesc(Xrot), colormap([0 0 0; cm])    
    subplot(1,2,2), semilogy(diag(S),'-o','color',cm(j,:))       
end
axis([1.e-16 1.e3 -10 1000])
set(gca,'XTick',[0 250 500 750 1000])
set(gca,'YTick',[1.e-16 1.e-12 1.e-8 1.e-4 1. 1.e4]);
set(gcf,'Position',[100 100 550 230])
