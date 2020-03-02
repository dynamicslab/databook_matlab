clear all; close all; clc

% training & testing set sizes
n1=100;  % training set size
n2=50;   % test set size

% random ellipse 1 centered at (0,0)
x=randn(n1+n2,1);
y=0.5*randn(n1+n2,1);

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
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(x3(1:n1),y3(1:n1),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)

% training set:  first 200 of 240 points
X1=[x3(1:n1) y3(1:n1)];
X2=[x(1:n1) y(1:n1)];

figure(1)
Y3=[X1(1:50,:); X2(1:50,:)];
Y2 = pdist(Y3,'euclidean');
Z = linkage(Y2,'average');
thresh=0.85*max(Z(:,3));
[H,T,O]=dendrogram(Z,100,'ColorThreshold',thresh);
axis off

figure(5) 
bar(O,'FaceColor',[.6 .6 .6],'EdgeColor','k')
axis([0 100 0 100])
set(gca,'Fontsize',[15])
hold on
plot([0 100],[50 50],'r:','Linewidth',[2])
plot([50.5 50.5],[0 100],'r:','Linewidth',[2])


thresh=0.25*max(Z(:,3));
[H,T,O]=dendrogram(Z,100,'ColorThreshold',thresh);
axis off
