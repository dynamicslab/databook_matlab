clear all; close all; clc;

load catData_w.mat
load dogData_w.mat
CD=[dog_wave cat_wave];
[u,s,v]=svd(CD-mean(CD(:)));

xtrain=[v(1:60,2:2:4); v(81:140,2:2:4)];
label=[ones(60,1); -1*ones(60,1)];
test=[v(61:80,2:2:4); v(141:160,2:2:4)];

class=classify(test,xtrain,label);
subplot(4,1,3), bar(class,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis off

truth=[ones(20,1); -1*ones(20,1)];
E=100-sum(0.5*abs(class-truth))/40*100

plot(v(1:80,2),v(1:80,4),'ro','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0 1 0.2],'MarkerSize',8), hold on
plot(v(81:end,2),v(81:end,4),'bo','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0.9 0 1],'MarkerSize',8), set(gca,'Fontsize',[15])

figure(2)
for j=1:2
    subplot(2,2,j)
    U3=flipud(reshape(u(:,2*j),32,32));
    pcolor(U3), colormap(hot), axis off
end


%%
load dogData.mat
load catData.mat
CD=double([dog cat]);
[u,s,v]=svd(CD-mean(CD(:)));

xtrain=[v(1:60,2:2:4); v(81:140,2:2:4)];
label=[ones(60,1); -1*ones(60,1)];
test=[v(61:80,2:2:4); v(141:160,2:2:4)];

class=classify(test,xtrain,label);
subplot(4,1,4), bar(class,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis off









%% cross-validate

for jj=1:100;   
    r1=randperm(80); r2=randperm(80);
    ind1=r1(1:60); ind2=r2(1:60)+60;
    ind1t=r1(61:80); ind2t=r2(61:80)+60;
    
    xtrain=[v(ind1,2:2:4); v(ind2,2:2:4)];
    test=[v(ind1t,2:2:4); v(ind2t,2:2:4)];
    
    label=[ones(60,1); -1*ones(60,1)];
    truth=[ones(20,1); -1*ones(20,1)];
    class=classify(test,xtrain,label);
    E(jj)=sum(abs(class-truth))/40*100;    
end


figure(4)
bar(E,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis([0 100 0 100])
hold on
plot([0 100],[mean(E) mean(E)],'r:','Linewidth',[2])
set(gca,'Fontsize',[15])



%%
close all
figure(1)
load catData_w.mat
load dogData_w.mat
CD=[dog_wave cat_wave];
[u,s,v]=svd(CD-mean(CD(:)));


for j=1:2
    subplot(2,2,j)
    plot(v(1:80,2),v(1:80,4),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 1 0.2],...
        'MarkerSize',8), hold on   % [0.49 1 .63]
    plot(v(81:end,2),v(81:end,4),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0.9 0 1],...
        'MarkerSize',8)
    set(gca,'Fontsize',[15]), hold on
end

xtrain=[v(1:60,2:2:4); v(81:140,2:2:4)];
label=[ones(60,1); -1*ones(60,1)];
test=[v(61:80,2:2:4); v(141:160,2:2:4)];

subplot(2,2,1)
[class,~,~,~,coeff]=classify(test,xtrain,label);
K = coeff(1,2).const;
L = coeff(1,2).linear;
f = @(x,y) K + [x y]*L;
h2 = ezplot(f,[-.15 0.25 -.3 0.2]);
set(h2,'Linecolor','k','Linewidth',[2])
xlabel(''),ylabel(''),title('')

subplot(2,2,2)
[class,~,~,~,coeff]=classify(test,xtrain,label,'quadratic');
K = coeff(1,2).const;
L = coeff(1,2).linear;
Q = coeff(1,2).quadratic;
f = @(x,y) K + [x y]*L + sum(([x y]*Q) .* [x y], 2);
h2 = ezplot(f,[-.15 0.25 -.3 0.2]);
set(h2,'Linecolor','k','Linewidth',[2])
xlabel(''),ylabel(''),title('')


%set(gca,'Linewidth',[2])
%set(gcf,'LineStyle','k-')


%% figure 0
figure(5), subplot(2,2,1)

load catData_w.mat
load dogData_w.mat
CD=[dog_wave cat_wave];
[u,s,v]=svd(CD-mean(CD(:)));

plot(v(1:80,2),v(1:80,4),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0 1 0.2],...
    'MarkerSize',8), hold on   % [0.49 1 .63]
plot(v(81:end,2),v(81:end,4),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
    'MarkerFaceColor',[0.9 0 1],...
    'MarkerSize',8)
axis off

x=linspace(-0.1,-.4,200); %x2=cos(theta)*x + sin(theta)*y;
y=0.2*exp(-1000*(x2+0.25).^2);
theta=-20; Ar=[cos(theta) sin(theta); -sin(theta) cos(theta)];
%x2=cos(theta)*x + sin(theta)*y;
%y2=-sin(theta)*x + cos(theta)*y;
hold on
fill(x,y,[240 194 224]/255,'MarkerEdgeColor',[0.9 0 1],'Linewidth',[2])
set(gca,'Fontsize',[15])


plot([-0.05  0.25],[-.5 -0.25],'k')

clear x
clear y
figure(6)
x=-7:0.01:7;
y=exp(-(x-2).^2);
yn=y/trapz(x,y);
y2=exp(-0.5*(x+2).^2);
yn2=y2/trapz(x,y2);
fill(x,yn,[240 194 224]/255,'Linewidth',[2]), axis off
hold on
fill(x,yn2,[179 255 179]/255,'Linewidth',[2]),
alpha(0.5)
set(gca,'Linewidth',[2])

figure(7)
y=exp(-0.3*(x-0.6).^2);
yn=y/trapz(x,y);
y2=exp(-0.2*(x+0.5).^2);
yn2=y2/trapz(x,y2);
fill(x,yn,[240 194 224]/255,'Linewidth',[2]), axis off
hold on
fill(x,yn2,[179 255 179]/255,'Linewidth',[2]),
alpha(0.5)
set(gca,'Linewidth',[2])





