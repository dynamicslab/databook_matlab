clear all; close all; clc

% training & testing set sizes
n1=100;  % training set size
n2=50;   % test set size

% random ellipse 1 centered at (0,0)
x=randn(n1+n2,1)-2;
y=0.5*randn(n1+n2,1);

x5=2*randn(n1+n2,1)+1;
y5=0.5*randn(n1+n2,1);


% random ellipse 2 centered at (1,-2)
x2=randn(n1+n2,1)+2;
y2=0.2*randn(n1+n2,1)-2;

% rotate ellipse 2 by theta
theta=pi/4;
A=[cos(theta) -sin(theta); sin(theta) cos(theta)];
x3=A(1,1)*x2+A(1,2)*y2;
y3=A(2,1)*x2+A(2,2)*y2;



subplot(2,2,1)
plot(x(1:n1),y(1:n1),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(x3(1:n1),y3(1:n1),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8)
axis([-6 6 -2 2]), set(gca,'Fontsize',[14])
            
subplot(2,2,2)
plot(x(1:70),y(1:70),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(x3(1:70),y3(1:70),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8)
plot(x(71:100),y(71:100),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(x3(71:100),y3(71:100),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
axis([-6 6 -2 2]), set(gca,'Fontsize',[14])

subplot(2,2,3)
plot(x5(1:n1),y5(1:n1),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(x3(1:n1),y3(1:n1),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8)
axis([-6 6 -2 2]), set(gca,'Fontsize',[14])
            
subplot(2,2,4)
plot(x5(1:70),y5(1:70),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(x3(1:70),y3(1:70),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.8 0.8 0.8],...
                'MarkerSize',8)
plot(x5(71:100),y5(71:100),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(x3(71:100),y3(71:100),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
axis([-6 6 -2 2]), set(gca,'Fontsize',[14])

%%
figure(2)
% random ellipse 1 centered at (0,0)
subplot(2,2,1)
n1=300;  % training set size
x1=1.5*randn(n1,1)-1.5;
y1=1.2*randn(n1,1)+(x1+1.5).^2-7;
x2=1.5*randn(n1,1)+1.5;
y2=1.2*randn(n1,1)-(x2-1.5).^2+7;


plot(x1,y1,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on
plot(x2,y2,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)            
axis([-6 6 -12 12]), set(gca,'Fontsize',[14])


subplot(2,2,2)
r=7+randn(n1,1);
th=2*pi*rand(n1,1);
xr=r.*cos(th);
yr=r.*sin(th);
x5=randn(n1,1);
y5=randn(n1,1);
plot(xr,yr,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on
plot(x5,y5,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)            
axis([-10 10 -10 10]), set(gca,'Fontsize',[14])
