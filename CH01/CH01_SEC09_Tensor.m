clear all; close all; clc


% A=randn(10,10,10);
% model=parafac(A,3);
% [A1,A2,A3]=fac2let(model)


x=-5:0.1:5; y=-6:0.1:6; t=0:0.1:10*pi;
[X,Y,T]=meshgrid(x,y,t);
A=exp(-(X.^2+0.5*Y.^2)).*(cos(2*T))+ ...
    (sech(X).*tanh(X).*exp(-0.2*Y.^2)).*sin(T);

for j=1:length(t)
  pcolor(x,y,A(:,:,j)), shading interp, caxis([-1 1]), drawnow
end

figure(1)
for j=1:8
  subplot(2,4,j)
  pcolor(x,y,A(:,:,8*j-3)), colormap(hot), shading interp, caxis([-1 1]), axis off
end


figure(2)
model=parafac(A,2);
[A1,A2,A3]=fac2let(model);
subplot(3,1,1), plot(y,A1,'Linewidth',[2])
subplot(3,1,2), plot(x,A2,'Linewidth',[2])
subplot(3,1,3), plot(t,A3,'Linewidth',[2])

subplot(3,1,1), set(gca,'Xtick',[-6 0 6],'Fontsize',[15])
subplot(3,1,2), set(gca,'Xtick',[-5 0 5],'Fontsize',[15])
subplot(3,1,3), set(gca,'Xlim',[0 10*pi],'Xtick',[0 5*pi 10*pi],'Xticklabels',{'0','5\pi','10\pi'},'Fontsize',[15])




