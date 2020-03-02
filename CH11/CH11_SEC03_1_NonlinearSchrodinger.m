clear all; close all; clc

L=40; n=512; x2=linspace(-L/2,L/2,n+1); x=x2(1:n); % spatial discretization
k=(2*pi/L)*[0:n/2-1 -n/2:-1].';  % wavenumbers for FFT
t=linspace(0,2*pi,21);           % time domain collection points

N=1;
u=N*sech(x);           % initial conditions
ut=fft(u);             % FFT initial data
[t,utsol]=ode45('nls_rhs',t,ut,[],k); % integrate PDE
for j=1:length(t)
  usol(j,:)=ifft(utsol(j,:));         % transforming back
end

N=2;
u2=N*sech(x);
ut=fft(u2);
[t,utsol2]=ode45('nls_rhs',t,ut,[],k);
for j=1:length(t)
  usol2(j,:)=ifft(utsol2(j,:));
end

figure(1)
subplot(2,2,1)
waterfall(x,t,abs(usol)), shading interp, colormap([0 0 0])
%hold on
%pcolor(x,t,abs(usol)), shading interp, %colormap(gray)
view(20,25)
set(gca,'Xlim',[-20 20],'Ylim',[0 2*pi],'Zlim',[0 1],'Xtick',[-20 -10 0 10 20],'Ytick',[0 3 6],'Ztick',[0 0.5 1], ...
    'Fontsize',[15]);
subplot(2,2,3)
waterfall(fftshift(k),t,abs(fftshift(utsol))), shading interp, colormap([0 0 0])
view(20,25)
set(gca,'Xlim',[-40 40],'Ylim',[0 2*pi],'Zlim',[0 40],'Xtick',[-40 -20 0 20 40],'Ytick',[0 3 6],'Ztick',[0 20 40], ...
    'Fontsize',[15]);


figure(1)
subplot(2,2,2)
waterfall(x,t,abs(usol2)), shading interp, colormap([0 0 0])
%hold on
%pcolor(x,t,abs(usol2)), shading interp, %colormap(gray)
view(20,25)
set(gca,'Xlim',[-20 20],'Ylim',[0 2*pi],'Zlim',[0 4],'Xtick',[-20 -10 0 10 20],'Ytick',[0 3 6],'Ztick',[0 2 4], ...
    'Fontsize',[15]);
subplot(2,2,4)
waterfall(fftshift(k),t,abs(fftshift(utsol2))), shading interp, colormap([0 0 0])
view(20,25)
set(gca,'Xlim',[-40 40],'Ylim',[0 2*pi],'Zlim',[0 80],'Xtick',[-40 -20 0 20 40],'Ytick',[0 3 6],'Ztick',[0 40 80], ...
    'Fontsize',[15]);



[U,S,V]=svd(usol.');
[U2,S2,V2]=svd(usol2.');

%%

figure(2)
subplot(3,2,1)
semilogy(100*diag(S)/sum(diag(S)),'ko','Linewidth',[2]), grid on, hold on
semilogy(100*S(1,1)/sum(diag(S)),'bo','Linewidth',[2]), 
semilogy(2,100*S(2,2)/sum(diag(S)),'go','Linewidth',[2]), 
semilogy(3,100*S(3,3)/sum(diag(S)),'ro','Linewidth',[2]), 

set(gca,'Xlim',[0 21],'Xtick',[1 6 11 16 21],'Ylim',[10^(-8) 10^3],'Ytick',[10^(-6) 10^(-3) 10^0 10^3],'Fontsize',[15])
xlabel('')

subplot(3,2,2)
semilogy(100*diag(S2)/sum(diag(S2)),'ko','Linewidth',[2]), grid on, hold on
semilogy(100*S2(1,1)/sum(diag(S2)),'bo','Linewidth',[2]), 
semilogy(2,100*S2(2,2)/sum(diag(S2)),'go','Linewidth',[2]), 
semilogy(3,100*S2(3,3)/sum(diag(S2)),'ro','Linewidth',[2]), 

set(gca,'Xlim',[0 21],'Xtick',[1 6 11 16 21],'Ylim',[10^(-8) 10^3],'Ytick',[10^(-6) 10^(-3) 10^0 10^3],'Fontsize',[15])
xlabel('')

subplot(3,1,2)
sn=[-1 -1 1 -1 -1];
for j=1:5
  nrm=1;
  Up(:,j)=real(U(:,j))*sn(j)/nrm;
end
plot(x,real(Up(:,2)),'g','Linewidth',[2]), hold on
plot(x,real(Up(:,3)),'r','Linewidth',[2])
plot(x,real(Up(:,1)),'b','Linewidth',[2])
set(gca,'Xlim',[-10 10],'Xtick',[-10 -5 0 5 10],'Ylim',[-0.1 0.2],'Ytick',[-0.1 0 0.1 0.2],'Fontsize',[15])
subplot(3,1,3)
sn=[-1 -1 1 -1 -1];
for j=1:5
  nrm=sqrt(trapz(x,U2(:,j).^2));
  nrm=1;
  Up2(:,j)=real(U2(:,j))*sn(j)/nrm;
end
plot(x,real(Up2(:,3)),'r','Linewidth',[2]), hold on
plot(x,real(Up2(:,2)),'g','Linewidth',[2])
plot(x,real(Up2(:,1)),'b','Linewidth',[2])
set(gca,'Xlim',[-10 10],'Xtick',[-10 -5 0 5 10],'Ylim',[-0.3 0.3],'Ytick',[-0.3 0 0.3],'Fontsize',[15])
legend('mode 3','mode 2','mode 1')








