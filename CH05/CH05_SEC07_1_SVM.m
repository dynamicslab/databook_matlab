clear all; close all; clc

figure(1)
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


figure(2)

z1=x1.^2.*y1;
z2=x2.^2.*y2;

plot3(x1,y1,z1,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on
plot3(x2,y2,z2,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)    
            grid on
%axis([-6 6 -12 12]), set(gca,'Fontsize',[14])

figure(3)



%subplot(2,2,2)
r=7+randn(n1,1);
th=2*pi*rand(n1,1);
xr=r.*cos(th);
yr=r.*sin(th);
x5=randn(n1,1);
y5=randn(n1,1);

zr=(xr.^2+yr.^2);
z5=(x5.^2+y5.^2);

plot3(xr,yr,zr+40,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on
plot3(x5,y5,z5+40,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)            
x=-10:0.5:10; y=x; 
[X,Y]=meshgrid(x,y); F3=54+0*X+0*Y;
surfl(X,Y,F3), shading interp, colormap(gray), alpha(0.2)

plot(xr,yr,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[179 255 179]/255,...
                'MarkerSize',8), hold on
plot(x5,y5,'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[240 194 224]/255,...
                'MarkerSize',8)            

theta=linspace(0,2*pi,100);
xrr=sqrt(14)*cos(theta);
yrr=sqrt(14)*sin(theta);
plot3(xrr,yrr,0*xrr,'k-','Linewidth',[2])
            
            grid on
%Plane([0, 0, 0], [0, 0, 1], Color = RGB::Blue)            
            
axis([-10 10 -10 10 0 140]), set(gca,'Fontsize',[14])
set(gca,'Ztick',[40 90 140],'Zticklabels',{'0','50','100'})
view(115,25)

%% classify dog vs cats

load catData_w.mat
load dogData_w.mat
CD=[dog_wave cat_wave];
[u,s,v]=svd(CD-mean(CD(:)));

features=1:20;
xtrain=[v(1:60,features); v(81:140,features)];          
label=[ones(60,1); -1*ones(60,1)];
test=[v(61:80,features); v(141:160,features)]; 
truth=[ones(20,1); -1*ones(20,1)];

Mdl = fitcsvm(xtrain,label);
test_labels = predict(Mdl,test);

Mdl = fitcsvm(xtrain,label,'KernelFunction','RBF');
test_labels = predict(Mdl,test);
CMdl = crossval(Mdl);        % cross-validate the model
classLoss = kfoldLoss(CMdl)  % compute class loss 





