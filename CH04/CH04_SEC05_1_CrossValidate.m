clear all; close all; clc

n=200; L=8;
x=linspace(0,L,n);
x1=x(1:100);   % train
x2=x(101:200); % test
n1=length(x1);
n2=length(x2);
ftrain=(x1.^2).';  % train parabola x=[0,4]
ftest=(x2.^2).';   % test parbola x=[4,5]
figure(1), subplot(3,1,1),
plot(x1,ftrain,'r',x2,ftest,'b','Linewidth',[2])
legend('','','Location','Northwest')
legend boxoff

M=30; % number of model terms
Eni=zeros(100,M); Ene=zeros(100,M);
for jj=1:M
    for j=1:jj
        phi_i(:,j)=(x1.').^(j-1); % interpolation key
        phi_e(:,j)=(x2.').^(j-1); % extrapolation key
    end
    
    f=(x.^2).';
    for j=1:100
        fni=(x1.^2+0.1*randn(1,n1)).'; % interpolation
        fne=(x2.^2+0.1*randn(1,n2)).'; % extrapolation
        
        ani=pinv(phi_i)*fni; fnai=phi_i*ani;
        Eni(j,jj)=norm(ftrain-fnai)/norm(ftrain);
        
        fnae=phi_e*ani;  % use loadings from x in [0,4]
        Ene(j,jj)=norm(ftest-fnae)/norm(ftest);
    end
end

subplot(3,2,3), boxplot(Eni), axis([0.5 30.5 0 0.7]), set(gca,'Xlim',[0.5 30.5],'Xtick',1:30,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20','','','','','25','','','','','30'})
subplot(3,2,4), boxplot(Eni), axis([0.5 30.5 0 0.02]), set(gca,'Xlim',[0.5 30.5],'Xtick',1:30,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20','','','','','25','','','','','30'})
subplot(3,2,5), boxplot(Ene), set(gca,'Xlim',[0.5 30.5],'Xtick',1:30,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20','','','','','25','','','','','30'})
subplot(3,2,6), boxplot(log(Ene+1)), axis([0.5 30.5 0 30]), set(gca,'Xtick',1:30,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20','','','','','25','','','','','30'})

