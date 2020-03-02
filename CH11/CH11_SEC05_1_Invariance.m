clear all; close all; clc

n=100;
L=20; x=linspace(-L,L,n); y=x;
[X,Y]=meshgrid(x,y);

Xd=[];
for j=1:100
    u=tanh(sqrt(X.^2+Y.^2)).*cos(angle(X+i*Y)-(sqrt(X.^2+Y.^2))+j/10);
    f=exp(-0.01*(X.^2+Y.^2));
    uf=u.*f;
    Xd(:,j)=reshape(uf,n^2,1);
    pcolor(x,y,uf), shading interp, colormap(hot) 
end



%%
[U,S,V]=svd(Xd,0);

figure(2)
subplot(4,1,3)
plot(100*diag(S)/sum(diag(S)),'ko','Linewidth',[2])
subplot(4,1,4)
semilogy(100*diag(S)/sum(diag(S)),'ko','Linewidth',[2])
subplot(2,1,1)
plot(V(:,1:4),'Linewidth',[2])
legend('mode1','mode2','mode3','mode4')
set(gca,'Fontsize',[15],'Xtick',[0 20 40 60 80 100])
subplot(4,1,3), set(gca,'Fontsize',[15],'Ylim',[0 60],'Ytick',[0 20 40 60],'Xlim',[0 40],'Xtick',[0 10 20 30 40])
subplot(4,1,4), set(gca,'Fontsize',[15],'Ylim',[10^(-20) 10^2],'Ytick',[10^(-20) 10^(-10) 10^2],'Xlim',[0 40],'Xtick',[0 10 20 30 40])

figure(3)
for j=1:4
    subplot(4,4,j)
    mode=reshape(U(:,j),n,n);
    pcolor(X,Y,mode), shading interp,caxis([-0.03 0.03]), colormap(gray)
    axis off
end

%%

figure(11)
u=tanh(sqrt(X.^2+Y.^2)).*cos(angle(X+i*Y)-(sqrt(X.^2+Y.^2)));
f=exp(-0.01*(X.^2+Y.^2));
uf=u.*f;
subplot(3,3,1),pcolor(x,y,uf), shading interp, caxis([-1 1]), axis off
subplot(3,3,2),pcolor(x,y,abs(uf)), shading interp, caxis([-1 1]), axis off
subplot(3,3,3),pcolor(x,y,uf.^5), shading interp, caxis([-1 1]), axis off
colormap(gray)




%% TRANSLATION
figure(5)
n=200; L=20; x=linspace(-L,L,n); y=x;  % space
m=41; T=10; t=linspace(0,T,m);         % time
c=3;   % wave speed

X=[];
for j=1:m
    X(:,j)=exp(-(x+15-c*t(j)).^2).';  % data snapshots
end
[U,S,V]=svd(X);  % SVD decomposition


%%
figure(6)
subplot(2,2,1)
waterfall(x,t,X.'),colormap([0 0 0])
view(20,75)
set(gca,'Xlim',[-20 20],'Xtick',[-20 -10 0 10 20],'Ylim',[0 10], ...
    'Ytick',[0 5 10],'Zlim',[0 1],'Ztick',[0  1],'Fontsize',[12])


[U2,S2,V2]=svd(X);

subplot(4,2,2)
plot(100*diag(S2)/sum(diag(S2)),'ko','Linewidth',[2])
set(gca,'Xlim',[0 40],'Xtick',0:10:40,'Ylim',[0 8],'Ytick',[0 4 8])
subplot(4,2,4)
semilogy(100*diag(S2)/sum(diag(S2)),'ko','Linewidth',[2])
grid on
set(gca,'Xlim',[0 40],'Xtick',0:10:40,'Ylim',[10^(-3) 2*10^1],'Ytick',[10^(-3) 10^(-2) 10^(-1) 10^0 10^1])

figure(8)
subplot(2,1,1)
plot(x,U2(:,1:4),'Linewidth',[2]);
legend('mode1','mode2','mode3','mode4','Location','SouthEast')
set(gca,'Fontsize',[15],'Ylim',[-0.15 0.15],'Ytick',[-0.15 0 0.15])
subplot(2,1,2)
plot(t,V2(:,1:4),'Linewidth',[2])
set(gca,'Fontsize',[15],'Ylim',[-.3 0.3],'Ytick',[-0.3 0 0.3])

