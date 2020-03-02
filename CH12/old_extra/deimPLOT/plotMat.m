clear all; close all; clc

L=4; x=-L:0.2:L; n=length(x); dx=x(2)-x(1);

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

%%
 figure(4)
 axes('position',[.1 .1 .25 .85])
 pcolor((-ysolb(:,:))), colormap(gray)
% colormap(cc)
 axis off
 box on
% 
% set(gcf,'Position',[100 100 200 625])
% 

%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)

P=zeros(10,41);
%P(1,21)=-10; 
P(2,21)=-10;
%P(2,26)=-10; 
P(3,26)=-10;
P(4,30)=-10;



%rectangle('Position',[0.1, 0.1, 0.2, 0.2],'Linewidth',2,'Edgecolor','r'), axis off

axes('position',[.05 .6 .6 .03])

pcolor(flipud((P(1:2,:)))), colormap(gray), caxis([-10 0])
%colormap(cc)
axis off
box on

hold on

axes('position',[.7 .05 .03 .9])
pcolor(-ysolb(:,1:2)), colormap(gray), %caxis([-1 1])
axis off
box on

% residual
A=(-1/10)*P(2,:)*ysolb(:,1)
b=(-1/10)*P(2,:)*ysolb(:,2)
c=A\b;
r=ysolb(:,2)-ysolb(:,1)*c;
r2=[r r];

axes('position',[.9 .05 .03 .9])
pcolor(r2), colormap(gray), %caxis([-1 1])
axis off
box on




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)

P=zeros(10,41);
%P(1,21)=-10; 
P(2,21)=-10;
%P(2,26)=-10; 
P(3,26)=-10;
P(4,30)=-10;

%rectangle('Position',[0.1, 0.1, 0.2, 0.2],'Linewidth',2,'Edgecolor','r'), axis off

axes('position',[.05 .6 .6 .06])

pcolor(flipud((P(1:3,:)))), colormap(gray), caxis([-10 0])
%colormap(cc)
axis off
box on

hold on

axes('position',[.7 .05 .06 .9])
pcolor(-ysolb(:,1:3)), colormap(gray), %caxis([-1 1])
axis off
box on

% residual
A=(-1/10)*P(2:3,:)*ysolb(:,1:2)
b=(-1/10)*P(2:3,:)*ysolb(:,3)
c=A\b;
r=ysolb(:,3)-ysolb(:,1:2)*c;
r2=[r r];


axes('position',[.9 .05 .03 .9])
pcolor(r2), colormap(gray), %caxis([-1 1])
axis off
box on



%rectangle('Position',[0.1, 0.1, 0.5, 0.5],'Linewidth',2,'Edgecolor','r')
%break

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)

P=zeros(10,41);
%P(1,21)=-10; 
P(2,21)=-10;
%P(2,26)=-10; 
P(3,26)=-10;
P(4,18)=-10;

axes('position',[.05 .6 .6 .09])

pcolor(flipud((P(1:4,:)))), colormap(gray), caxis([-10 0])
%colormap(cc)
axis off
box on

hold on

axes('position',[.7 .05 .09 .9])
pcolor(-ysolb(:,1:4)), colormap(gray), %caxis([-1 1])
axis off
box on

% residual
A=(-1/10)*P(2:4,:)*ysolb(:,1:3)
b=(-1/10)*P(2:4,:)*ysolb(:,4)
c=A\b;
r=ysolb(:,4)-ysolb(:,1:3)*c;
r2=[r r];

axes('position',[.9 .05 .03 .9])
pcolor(r2), colormap(gray), %caxis([-1 1])
axis off
box on







