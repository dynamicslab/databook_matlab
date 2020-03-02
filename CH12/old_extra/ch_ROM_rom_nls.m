clear all; close all; clc

L=30; n=256;
x2=linspace(-L/2,L/2,n+1); x=x2(1:n);
k=(2*pi/L)*[0:n/2-1 -n/2:-1].';
t=linspace(0,2*pi,51);

u=2*sech(x);
ut=fft(u);

[t,utsol]=ode45('nls_rhs',t,ut,[],k);

for j=1:length(t)
   usol(j,:)=ifft(utsol(j,:));
end

figure(1), subplot(2,2,1),surfl(x,t,abs(usol)); shading interp, colormap(gray);

%% SVD 

X=usol.';
[u,s,v]=svd(X);
figure(2)
plot(diag(s)/sum(diag(s)),'ko','Linewidth',[2])

figure(3)
plot(real(u(:,1:3)),'Linewidth',[2]), figure(4)

%%
r=4;  % rank of projection
phi=u(:,1:r);  % Phi_r POD modes

for j=1:r
  phixx(:,j)=  -ifft((k.^2).*fft(phi(:,j))); % second derivatives
  a0(j)= 2*sech(x)*conj(phi(:,j));  % projection of initial conditions
end
L= (i/2)* phi'*phixx;  % Low-rank approximation of linear term

[t,asol]=ode45('ch_rom_a_rhs',t,a0,[],phi,L);
  
us=zeros(n,length(t));
for j=1:length(t)
    for jj=1:r
       us(:,j)=us(:,j) + asol(j,jj)*phi(:,jj);  % r-rank reconstruction
    end
end

surfl(x,t,abs(us.')); shading interp, colormap(gray);

figure(1)
subplot(2,2,2)
surfl(x,t,abs(us.')); shading interp, colormap(gray);
set(gca,'Xlim',[-15 15],'Ylim',[0 2*pi],'Zlim',[0 4],'Xtick',[-15 0 15],'Ytick',[0 pi 2*pi],'Yticklabel',{'0','\pi','2\pi'},'Ztick',[0 2 4],'Fontsize',[15])
% zlabel('|u|','Fontsize',[15])
% xlabel('x','Fontsize',[15])
% ylabel('t','Fontsize',[15])
% text(-20,5,'(b)','Fontsize',[15])

subplot(2,2,1)
set(gca,'Xlim',[-15 15],'Ylim',[0 2*pi],'Zlim',[0 4],'Xtick',[-15 0 15],'Ytick',[0 pi 2*pi],'Yticklabel',{'0','\pi','2\pi'},'Ztick',[0 2 4],'Fontsize',[15])
% zlabel('|u|','Fontsize',[15])
% xlabel('x','Fontsize',[15])
% ylabel('t','Fontsize',[15])
% text(-20,10,'(a)','Fontsize',[15])








