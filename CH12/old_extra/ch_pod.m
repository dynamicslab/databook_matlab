clear all; close all; clc

L=20; n=80;
x2=linspace(-L/2,L/2,n+1);
x=x2(1:n);
u=exp(-x.^2); u1=exp(-0.1*x.^2); u2=exp(-10*x.^2);
ut=fft(u); uts=fftshift(ut);
ut1=fft(u1); uts1=fftshift(ut1);
ut2=fft(u2); uts2=fftshift(ut2);

k=(2*pi/L)*[0:(n/2-1) (-n/2):-1];
km=[0:n/2-1 -n/2:-1];


subplot(3,2,1), plot(x,u2,'b-o',x,u1,'r-o',x,u,'k-o')
set(gca,'Xlim',[-10 10],'Xtick',[-10  0  10],'Fontsize',[15])
text(-13.5,0.8,'u(x)','Fontsize',[15])
text(7,-0.2,'x','Fontsize',[15])
text(-8,0.8,'(a)','Fontsize',[15])




subplot(3,2,2), plot(km,abs(ut2)/max(abs(ut2)),'b-o',km,abs(ut1)/max(abs(ut1)),'r-o',km,abs(ut)/max(abs(ut)),'k-o')
set(gca,'Xlim',[-40 40],'Xtick',[-40   0 40],'Fontsize',[15])
text(-53,0.8,'u(k)','Fontsize',[15])
text(-53,0.86,'^','Fontsize',[15])
text(18,-0.2,'mode','Fontsize',[15])
text(-36,0.8,'(b)','Fontsize',[15])


ut21=zeros(1,n);
ut22=zeros(1,n);
ut23=zeros(1,n);

for j=1:19
   
   for jj=1:j
   
       ut21(n/2+1-jj:n/2+1+jj) = uts(n/2+1-jj:n/2+1+jj);
       ut22(n/2+1-jj:n/2+1+jj) = uts1(n/2+1-jj:n/2+1+jj);
       ut23(n/2+1-jj:n/2+1+jj) = uts2(n/2+1-jj:n/2+1+jj);
       
   end
   ut31=fftshift(ut21);
   ut32=fftshift(ut22);
   ut33=fftshift(ut23);
   u31=ifft(ut31);
   u32=ifft(ut32);
   u33=ifft(ut33);
   subplot(3,1,2)
   plot(x,u31,'k'), hold on 
   
%     figure(2)
%     subplot(2,1,1)
%    plot(x,u32,'k'), hold on 
% 
%     subplot(2,1,2)
%    plot(x,u33,'k'), hold on 
%     figure(1)

   
   
   
   erx(j)=2*j+1
   er1(j)=norm(u-u31);
   er2(j)=norm(u1-u32);
   er3(j)=norm(u2-u33);
   
   
end
subplot(3,1,3)
semilogy(erx,er3,'b',erx,er2,'r',erx,er1,'k','LineWidth',[2]), grid on

subplot(3,1,2), set(gca,'Xlim',[-10 10],'Xtick',[-10 -5 0 5 10],'Ylim',[-.2 1],'Ytick',[0 0.5 1],'Fontsize',[15])
text(-13,0.8,'u(x)','Fontsize',[15])
text(-0.5,0.1,'N=3','Fontsize',[15])
text(1,0.85,'N=39','Fontsize',[15])
A=annotation('textarrow',[0.52 0.52],[0.48 0.60]); set(A,'String','','Fontsize',15)
text(7,-0.4,'x','Fontsize',[15])
text(-9,0.8,'(c)','Fontsize',[15])



subplot(3,1,3), set(gca,'Fontsize',[15],'Ylim',[10^(-5) 10^1],'Ytick',[10^(-5) 10^(-4) 10^(-3) 10^(-2) 10^(-1) 10^(0) 10^(1)] )
text(-6,1,'Error','Fontsize',[15])
text(32,10^(-7),'# of modes','Fontsize',[15])
text(2,10^(-4),'(d)','Fontsize',[15])

figure(2)
subplot(2,1,1)

subplot(2,1,2)
figure(1)

