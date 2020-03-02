clear all; close all; clc

% training & testing set sizes
n1=100;  % training set size
n2=50;   % test set size

% random ellipse 1 centered at (0,0)
x=randn(n1+n2,1); y=0.5*randn(n1+n2,1);

% random ellipse 2 centered at (1,-2) and rotated by theta
x2=randn(n1+n2,1)+1; y2=0.2*randn(n1+n2,1)-2; theta=pi/4;
A=[cos(theta) -sin(theta); sin(theta) cos(theta)];
x3=A(1,1)*x2+A(1,2)*y2; y3=A(2,1)*x2+A(2,2)*y2;

subplot(2,2,1)
plot(x(1:n1),y(1:n1),'ro','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0 1 0.2],'MarkerSize',8), hold on   
plot(x3(1:n1),y3(1:n1),'bo','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0.9 0 1],'MarkerSize',8)

% training set:  first 200 of 240 points
X1=[x3(1:n1) y3(1:n1)];
X2=[x(1:n1) y(1:n1)];

Y=[X1; X2]; Z=[ones(n1,1); 2*ones(n1,1)];

% test set:  remaining 40 points
x1test=[x3(n1+1:end) y3(n1+1:end)];
x2test=[x(n1+1:end) y(n1+1:end)];












%%
figure(2)

g1=[-1 0]; g2=[1 0]; %  Initial guess
for j=1:4
    subplot(2,2,j)
    class1=[]; class2=[];
    for jj=1:length(Y)       
        d1=norm(g1-Y(jj,:));
        d2=norm(g2-Y(jj,:));
        if d1<d2
          class1=[class1; [Y(jj,1) Y(jj,2)]];  
        else
          class2=[class2; [Y(jj,1) Y(jj,2)]];
        end        
    end        
        
    plot(class1(1:end,1),class1(1:end,2),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8),hold on
    plot(class2(1:end,1),class2(1:end,2),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 0 0.9],...
                'MarkerSize',8)
    plot(g1(1),g1(2),'k*','Linewidth',[4]), 
    plot(g2(1),g2(2),'k*','Linewidth',[4]), hold off
    axis([-2 4 -3 2])

    g1=[mean(class1(1:end,1)) mean(class1(1:end,2))];
    g2=[mean(class2(1:end,1)) mean(class2(1:end,2))];
end


    plot(class1(1:end,1),class1(1:end,2),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8),hold on
    plot(class2(1:end,1),class2(1:end,2),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 0 0.9],...
                'MarkerSize',8)
    plot(g1(1),g1(2),'ko','Linewidth',[2]), 
    plot(g2(1),g2(2),'ko','Linewidth',[2]), 

    
% kmeans code    
[ind,c]=kmeans(Y,2);
plot(c(1,1),c(1,2),'k*','Linewidth',[2])
plot(c(2,1),c(2,2),'k*','Linewidth',[2])

midx=(c(1,1)+c(2,1))/2; midy=(c(1,2)+c(2,2))/2;
slope=(c(2,2)-c(1,2))/(c(2,1)-c(1,1)); % rise/run
b=midy+(1/slope)*midx;
xsep=-1:0.1:2; ysep=-(1/slope)*xsep+b;

figure(1), subplot(2,2,1), hold on
plot(xsep,ysep,'k','Linewidth',[2]),axis([-2 4 -3 2])

% error on test data
figure(1), subplot(2,2,2)
plot(x(n1+1:end),y(n1+1:end),'ro','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0 1 0.2],'MarkerSize',8), hold on
plot(x3(n1+1:end),y3(n1+1:end),'bo','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0.9 0 1],'MarkerSize',8), hold on
plot(xsep,ysep,'k','Linewidth',[2]), axis([-2 4 -3 2])




%% Dendrograms
figure(4)
Y3=[X1(1:50,:); X2(1:50,:)];

Y2 = pdist(Y3,'euclidean');
Z = linkage(Y2,'average');
thresh=0.85*max(Z(:,3));
[H,T,O]=dendrogram(Z,100,'ColorThreshold',thresh);
figure(5) 
bar(O), axis([0 100 0 100])
hold on
plot([0 100],[50 50],'r:','Linewidth',[2])
plot([50.5 50.5],[0 100],'r:','Linewidth',[2])

