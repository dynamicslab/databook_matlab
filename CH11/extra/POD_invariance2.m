clear all; close all; clc

n=100;
L=20; x=linspace(-L,L,n); y=x;
[X,Y]=meshgrid(x,y);

Xd=[];
for j=1:100
u=tanh(sqrt(X.^2+Y.^2)).*cos(angle(X+i*Y)-(sqrt(X.^2+Y.^2))+j/10);
f=exp(-0.01*(X.^2+Y.^2));
uf=u.*f;
Xd1(:,j)=reshape(abs(uf),n^2,1);
Xd2(:,j)=reshape(uf.^5,n^2,1);
%pcolor(x,y,uf), shading interp, colormap(hot), caxis([-1 1]), drawnow 
end



%%
[U1,S1,V1]=svd(Xd1,0);
[U2,S2,V2]=svd(Xd2,0);

figure(2)
subplot(4,1,1)
plot(100*diag(S1)/sum(diag(S1)),'ro','Linewidth',[2]), hold on
plot(100*diag(S2)/sum(diag(S2)),'bo','Linewidth',[2])
legend('|u|','u^5')
subplot(4,1,2)
semilogy(100*diag(S1)/sum(diag(S1)),'ro','Linewidth',[2]), hold on
semilogy(100*diag(S2)/sum(diag(S2)),'bo','Linewidth',[2])
grid on
subplot(4,1,3)
plot(V1(:,1:4),'Linewidth',[2])
set(gca,'Fontsize',[15],'Xtick',[0 20 40 60 80 100])
subplot(4,1,4)
plot(V2(:,1:4),'Linewidth',[2])
legend('mode1','mode2','mode3','mode4')
set(gca,'Fontsize',[15],'Xtick',[0 20 40 60 80 100])
subplot(4,1,1), set(gca,'Fontsize',[15],'Ylim',[0 60],'Ytick',[0 20 40 60],'Xlim',[0 40],'Xtick',[0 10 20 30 40])
subplot(4,1,2), set(gca,'Fontsize',[15],'Ylim',[10^(-20) 10^2],'Ytick',[10^(-20) 10^(-10) 10^2],'Xlim',[0 40],'Xtick',[0 10 20 30 40])


figure(3)
for j=1:4
  subplot(4,4,j)
  mode=reshape(U1(:,j),n,n);
  pcolor(X,Y,mode), shading interp,caxis([-0.03 0.03]), colormap(gray)
  axis off
  subplot(4,4,j+4)
  mode=reshape(U2(:,j),n,n);
  pcolor(X,Y,mode), shading interp,caxis([-0.03 0.03]), colormap(gray)
  axis off
end

