clear all; close all; clc;

%%
L=10; x3=-L:0.1:L; n=length(x3)-1; % define domain
x2=x3(1:n); k=(2*pi/(2*L))*[0:n/2-1 -n/2:-1]; % k-vector
ye=exp(-(x2.^2)); ye2=exp((x2.^2)/2); % define Gaussians
for j=0:9      % loop through 10 modes
  yd=real(ifft(((i*k).^j).*fft(ye))); % 2nd derivative 
  mode=((-1)^(j))*(((2^j)*factorial(j)*sqrt(pi))^(-0.5))*ye2.*yd;
  y(:,j+1)=(mode).';  % store modes as columns
end

x=x2(n/2+1-40:n/2+1+40);  % keep only -4<x<4
yharm=y(n/2+1-40:n/2+1+40,:); 

axes('position',[.13 .6 .77 .25])
pcolor(flipud((yharm(:,10:-1:1).'))) 
colormap(hot), axis off, box on
%%
figure(4)  % test function
n=length(x); 
f=(exp(-(x-0.5).^2)+3*exp(-2*(x+1.5).^2))';
subplot(2,1,1), plot(x,f,'k'), hold on

for j=1:10  % full reconstruction
  a(j,1)=trapz(x,f.*yharm(:,j));
end
f2=yharm*a;
subplot(2,1,1), plot(x,f2,'r')
Err(1)=norm(f2-f);  % reconstruction error

for j=1:10  % matrix M reconstruction
   for jj=1:j
       Area=trapz(x,yharm(:,j).*yharm(:,jj));
       M(j,jj)=Area;
       M(jj,j)=Area;
   end
end
figure(2), subplot(2,2,1), pcolor(10:-1:1,1:10,M'); 
colormap(hot), caxis([0 1]), axis off
cond(M)   % get condition number

c=['g','m','b']; % three different measurement masks
for jloop=1:3
    figure(1), subplot(6,1,3+jloop)
    s=(rand(n,1)>0.8);  % grab 20% random measurements
    bar(x,double(s)), axis([-4.2 4.2 0 1]), axis off
    
    figure(2)  % construct M_j
    for j=1:10
        for jj=1:j
            Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
            M2(j,jj)=Area; M2(jj,j)=Area;
        end
    end
    subplot(2,2,jloop+1), pcolor(10:-1:1,1:10,(M2'));
    colormap(hot), caxis([-0.1 .3]), axis off
    con(jloop)=cond(M2)
    
    for j=1:10  % reconstruction using gappy
        ftild(j,1)=trapz(x,s.*(f.*yharm(:,j)));
    end
    
    atild=M2\ftild;   % compute error
    f2=yharm*atild;
    figure(4),subplot(2,1,1),plot(x,f2,c(jloop))
    Err(jloop+1)=norm(f2-f);
end

figure(4)  % bar graph of condition number and error
con2=[1 con];
subplot(4,1,3)
bar(log(con2)+1); set(gca,'Xticklabel',{},'Yticklabel',{})

subplot(4,1,4)
bar(Err); set(gca,'Xticklabel',{},'Yticklabel',{})

subplot(2,1,1)
set(gca,'Xticklabel',{},'Yticklabel',{})



%%

L=4; x=-L:0.1:L; n=length(x); dx=x(2)-x(1);
A=zeros(n-2,n-2);
for j=1:n-2
   A(j,j)=-2-(dx^2)*x(j+1)^2;
end
for j=1:n-3
    A(j+1,j)=1;
    A(j,j+1)=1;
end
A(1,1)=A(1,1)+4/3; A(1,2)=A(1,2)-1/3;
A(n-2,n-2)=A(n-2,n-2)+4/3; A(n-2,n-3)=A(n-2,n-3)-1/3;

[V3,D]=eigs(-A,10,'SR');
V2=[4/3*V3(1,:)-1/3*V3(2,:)  ; V3;  4/3*V3(end,:)-1/3*V3(end-1,:)];
for j=1:10
   V(:,j)=V2(:,j)/sqrt(trapz(x,V2(:,j).^2));
end
[Esolbb,I]=sortrows(diag(D)/dx^2); Esolb=Esolbb.';
for j=1:10
  ysolb(:,j)=(V(:,I(j)));
end

figure(1)
axes('position',[.15 .6 .74 .25])
pcolor(flipud((-ysolb(:,:))).'), colormap(hot), axis off, box on
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


