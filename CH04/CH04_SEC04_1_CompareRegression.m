clear all; close all; clc

n=100; L=4;
x=linspace(0,L,n);
f=(x.^2).';                % parabola with 100 data points

M=20;                      % polynomial degree
for j=1:M
  phi(:,j)=(x.').^(j-1);            % build matrix A
end

for j=1:4
    fn=(x.^2+0.1*randn(1,n)).';
    an=pinv(phi)*fn; fna=phi*an;    % least-square fit
    En=norm(f-fna)/norm(f);
    subplot(4,2,4+j),bar(an) 
end

subplot(2,1,1), plot(x,f,'k'), hold on

%% different regressions
subplot(2,1,1)
lambda=0.1; phi2=phi(:,2:end);
for jj=1:100
  f=(x.^2+0.2*randn(1,n)).';
  a1=pinv(phi)*f; f1=phi*a1; E1(jj)=norm(f-f1)/norm(f);
  a2=phi\f; f2=phi*a2; E2(jj)=norm(f-f2)/norm(f);
  [a3,stats]=lasso(phi,f,'Lambda',lambda); f3=phi*a3; E3(jj)=norm(f-f3)/norm(f);
  [a4,stats]=lasso(phi,f,'Lambda',lambda,'Alpha',0.8); f4=phi*a4; E4(jj)=norm(f-f4)/norm(f);
a5=robustfit(phi2,f);f5=phi*a5;E5(jj)=norm(f-f5)/norm(f);
a6=ridge(f,phi2,0.5,0);f6=phi*a6;E6(jj)=norm(f-f6)/norm(f);
  
  A1(:,jj)=a1;A2(:,jj)=a2;A3(:,jj)=a3;A4(:,jj)=a4;A5(:,jj)=a5;A6(:,jj)=a6;
  plot(x,f), hold on
end
Err=[E1; E2; E3; E4; E5; E6];
Err2=[E1; E2; E3; E4; E5];

figure(2)
subplot(3,2,1), boxplot(A1.'), set(gca,'Xtick',1:20,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20'})
subplot(3,2,2), boxplot(A2.'), set(gca,'Xtick',1:20,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20'})
subplot(3,2,3), boxplot(A3.'), set(gca,'Xtick',1:20,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20'})
subplot(3,2,4), boxplot(A4.'), set(gca,'Xtick',1:20,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20'})
subplot(3,2,5), boxplot(A5.'), set(gca,'Xtick',1:20,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20'})
subplot(3,2,6), boxplot(A6.'), set(gca,'Xtick',1:20,'Xticklabel',{'1','','','','5','','','','','10','','','','','15','','','','','20'})

figure(3)
subplot(3,3,1), boxplot(Err.'), axis([0 7 0.02 0.07])

%%
clear phi
M=10;
En=zeros(100,M);
for jj=1:M
  for j=1:jj
    phi(:,j)=(x.').^(j-1);
  end
  f=(x.^2).';
  for j=1:100
    fn=(x.^2+0.1*randn(1,n)).';
    an=pinv(phi)*fn; fna=phi*an;
    En(j,jj)=norm(f-fna)/norm(f);
  end
end

figure(3)
subplot(3,3,2)
boxplot(En)

subplot(3,3,3)
boxplot(En), axis([0.5 10.5 0 0.008])
