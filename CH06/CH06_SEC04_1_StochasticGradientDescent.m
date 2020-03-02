clear all; close all; clc

h=0.1; x=-6:h:6; y=-6:h:6; n=length(x);
[X,Y]=meshgrid(x,y); clear x, clear y

F1=1.5-1.6*exp(-0.05*(3*(X+3).^2+(Y+3).^2));
F=F1 + (0.5-exp(-0.1*(3*(X-3).^2+(Y-3).^2)));
[dFx,dFy]=gradient(F,h,h);
 
x0=[4  0 -5]; y0=[0 -5  2]; col=['ro','bo','mo'];
for jj=1:3    
  q=randperm(n); i1=sort(q(1:10));
  q2=randperm(n); i2=sort(q2(1:10));
  x(1)=x0(jj); y(1)=y0(jj);
  f(1)=interp2(X(i1,i2),Y(i1,i2),F(i1,i2),x(1),y(1));
  dfx=interp2(X(i1,i2),Y(i1,i2),dFx(i1,i2),x(1),y(1));
  dfy=interp2(X(i1,i2),Y(i1,i2),dFy(i1,i2),x(1),y(1));
    
  tau=2;
  for j=1:50
    x(j+1)=x(j)-tau*dfx; % update x, y, and f
    y(j+1)=y(j)-tau*dfy;
    q=randperm(n); ind1=sort(q(1:10));
    q2=randperm(n); ind2=sort(q2(1:10));
    f(j+1)=interp2(X(i1,i2),Y(i1,i2),F(i1,i2),x(j+1),y(j+1))
    dfx=interp2(X(i1,i2),Y(i1,i2),dFx(i1,i2),x(j+1),y(j+1));
    dfy=interp2(X(i1,i2),Y(i1,i2),dFy(i1,i2),x(j+1),y(j+1));
    if abs(f(j+1)-f(j))<10^(-6) % check convergence
        break
    end
  end    
  if jj==1; x1=x; y1=y; f1=f; end
  if jj==2; x2=x; y2=y; f2=f; end
  if jj==3; x3=x; y3=y; f3=f; end
  clear x, clear y, clear f
end

figure(1)
contour(X,Y,F-1,10), colormap([0 0 0]), hold on
plot(x1,y1,'ro',x1,y1,'k:',x2,y2,'mo',x2,y2,'k:',x3,y3,'bo',x3,y3,'k:','Linewidth',[2])
set(gca,'Fontsize',[18])

figure(2)
surfl(X,Y,F), shading interp, colormap(gray), hold on
plot3(x1,y1,f1+.1,'ro',x1,y1,f1,'k:',x2,y2,f2+0.1,'mo',x2,y2,f2,'k:',x3,y3,f3+0.1,'bo',x3,y3,f3,'k:','Linewidth',[2])
set(gca,'Fontsize',[18])
axis([-6 6 -6 6]), view(-25,60)


