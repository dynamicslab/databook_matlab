clear all; close all; clc
h=0.5
x=-6:h:6;
y=-6:h:6;

[X,Y]=meshgrid(x,y);
F0=1.5-1.0*exp(-0.03*(3*(X).^2+(Y).^2));

F=1.5-1.6*exp(-0.05*(3*(X+3).^2+(Y+3).^2));
F2=F + (0.5-exp(-0.1*(3*(X-3).^2+(Y-3).^2)));

[dF0x,dF0y]=gradient(F0,h,h);
[dF2x,dF2y]=gradient(F2,h,h);

figure(1)
subplot(2,2,1)
surfl(X,Y,F0), colormap(gray), shading interp, %alpha(0.5)
hold on
contour(X,Y,F0-0.5,10,'Linewidth',[2]), %colormap([0 0 0])
axis([-6 6 -6 6])

subplot(2,2,2)
surfl(X,Y,F2), shading interp, colormap(gray), , alpha(1)
hold on
contour(X,Y,F2-1,10), %colormap([0 0 0])
%pcolor(X,Y,F2), shading interp
axis([-6 6 -6 6])

figure(2)
subplot(2,2,1)
surfl(X,Y,dF0x), colormap(gray), shading interp
set(gca,'Xlim',[-6 6],'Ylim',[-6 6])
subplot(2,2,3)
surfl(X,Y,dF0y), colormap(gray), shading interp
set(gca,'Xlim',[-6 6],'Ylim',[-6 6])

subplot(2,2,2)
surfl(X,Y,dF2x), colormap(gray), shading interp
set(gca,'Xlim',[-6 6],'Ylim',[-6 6])
subplot(2,2,4)
surfl(X,Y,dF2y), colormap(gray), shading interp
set(gca,'Xlim',[-6 6],'Ylim',[-6 6])

%% gradient descent

clear x
clear y
Fquad=X.^2+3*Y.^2;

x(1)=3; y(1)=2; % initial guess 
f(1)=x(1)^2+3*y(1)^2; % initial function value
for j=1:10
    del=(x(j)^2 +9*y(j)^2)/(2*x(j)^2 + 54*y(j)^2); 
    x(j+1)=(1-2*del)*x(j); % update values 
    y(j+1)=(1-6*del)*y(j);
    f(j+1)=x(j+1)^2+3*y(j+1)^2;
    
    if abs(f(j+1)-f(j))<10^(-6) % check convergence 
        break
    end
end

% figure(3)
% contour(X,Y,Fquad,40); colormap([0 0 0])
% hold on
% plot(x,y,'ro',x,y,'k:','Linewidth',[2])
% axis([-3 3 -3 3])

figure(3)
surfl(X,Y,Fquad), shading interp, alpha(0.4)
hold on
plot3(x,y,f,'ro','Linewidth',[2])
plot3(x,y,f,'k:','Linewidth',[2])
contour(X,Y,Fquad,40); colormap([0 0 0])
hold on
%plot(x,y,'ro',x,y,'k:','Linewidth',[2])
axis([-3 3 -3 3 0 40])
view(-50,55)
set(gca,'Fontsize',[12])

%% computing the gradient descent with fminsearch
clear F
clear F1

h=0.1;
x=-6:h:6;
y=-6:h:6;

[X,Y]=meshgrid(x,y);

F1=1.5-1.6*exp(-0.05*(3*(X+3).^2+(Y+3).^2));
F=F1 + (0.5-exp(-0.1*(3*(X-3).^2+(Y-3).^2)));
f=F;

dx=h; dy=h;
[dFx,dFy]=gradient(F,h,h);
[dfx,dfy]=gradient(f,dx,dy);

clear f
clear dfx
clear dfy
clear x
clear y

x0=[4  0 -5];
y0=[0 -5  2];
col=['ro','bo','mo'];
for jj=1:3
    
x(1)=x0(jj); y(1)=y0(jj);
f(1)=interp2(X,Y,F,x(1),y(1));
dfx=interp2(X,Y,dFx,x(1),y(1));
dfy=interp2(X,Y,dFy,x(1),y(1));

for j=1:10
    del=fminsearch('delsearch',0.2,[],x(end),y(end),dfx,dfy,X,Y,F); % optimal tau 
    x(j+1)=x(j)-del*dfx; % update x, y, and f 
    y(j+1)=y(j)-del*dfy; 
    f(j+1)=interp2(X,Y,F,x(j+1),y(j+1));
    dfx=interp2(X,Y,dFx,x(j+1),y(j+1));
    dfy=interp2(X,Y,dFy,x(j+1),y(j+1));
    
    if abs(f(j+1)-f(j))<10^(-6) % check convergence 
        break
    end
end

if jj==1
    x1=x; y1=y; f1=f;
end
if jj==2
    x2=x; y2=y; f2=f;
end
if jj==3
    x3=x; y3=y; f3=f;
end


clear x
clear y
clear f

end


figure(4)
%subplot(2,2,2)
    contour(X,Y,F-1,10), colormap([0 0 0])
    hold on
    plot(x1,y1,'ro',x1,y1,'k:',x2,y2,'mo',x2,y2,'k:',x3,y3,'bo',x3,y3,'k:','Linewidth',[2])
set(gca,'Fontsize',[18])

figure(5)
%subplot(2,2,1)
surfl(X,Y,F), shading interp, colormap(gray), %alpha(0.5)
hold on
%    contour(X,Y,F-1,10), colormap([0 0 0])
    plot3(x1,y1,f1+.1,'ro',x1,y1,f1,'k:',x2,y2,f2+0.1,'mo',x2,y2,f2,'k:',x3,y3,f3+0.1,'bo',x3,y3,f3,'k:','Linewidth',[2])
set(gca,'Fontsize',[18])
axis([-6 6 -6 6])
view(-25,60)

%% alternating descent
clear all; close all; clc
h=0.1;
x=-6:h:6;
y=-6:h:6;

[X,Y]=meshgrid(x,y);

F1=1.5-1.6*exp(-0.05*(3*(X+3).^2+(Y+3).^2));
F=F1 + (0.5-exp(-0.1*(3*(X-3).^2+(Y-3).^2)));

x0=[4  0 -5];
y0=[0 -5  2];
col=['ro','bo','mo'];
xa=zeros(1,5); y1=zeros(1,5); f=zeros(1,5)

for jj=1:3
    
xa(1)=x0(jj); ya(1)=y0(jj);
f(1)=interp2(X,Y,F,xa(1),ya(1));
    
fx=interp2(X,Y,F,xa(1),y); xa(2)=xa(1); [~,ind]=min(fx); ya(2)=y(ind); 
fy=interp2(X,Y,F,x,ya(2)); ya(3)=ya(2); [~,ind]=min(fy); xa(3)=x(ind); 

    fx=interp2(X,Y,F,xa(3),y); xa(4)=xa(3); [~,ind]=min(fx); ya(4)=y(ind); 
    fy=interp2(X,Y,F,x,ya(4)); ya(5)=ya(4); [~,ind]=min(fy); xa(5)=x(ind); 
    
    f(2)=interp2(X,Y,F,xa(2),ya(2));
    f(3)=interp2(X,Y,F,xa(3),ya(3));
    f(4)=interp2(X,Y,F,xa(4),ya(4));
    f(5)=interp2(X,Y,F,xa(5),ya(5));
    
if jj==1
    x1=xa; y1=ya; f1=f;
end
if jj==2
    x2=xa; y2=ya; f2=f;
end
if jj==3
    x3=xa; y3=ya; f3=f;
end


clear xa
clear ya

end


figure(6)
    contour(X,Y,F-1,10), colormap([0 0 0])
    hold on
%    plot(x1,y1,'ro',x1,y1,'k:','Linewidth',[2])
    plot(x1,y1,'ro',x1,y1,'k:',x2,y2,'mo',x2,y2,'k:',x3,y3,'bo',x3,y3,'k:','Linewidth',[2])
set(gca,'Fontsize',[18])

figure(7)
%subplot(2,2,1)
surfl(X,Y,F), shading interp, colormap(gray), %alpha(0.5)
hold on
%    contour(X,Y,F-1,10), colormap([0 0 0])
    plot3(x1,y1,f1+.1,'ro',x1,y1,f1,'k:',x2,y2,f2+0.1,'mo',x2,y2,f2,'k:',x3,y3,f3+0.1,'bo',x3,y3,f3,'k:','Linewidth',[2])
set(gca,'Fontsize',[18])
axis([-6 6 -6 6])
view(-25,60)

