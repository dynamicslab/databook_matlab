clear all; close all; clc

n=100; L=4;
x=linspace(0,L,n);
f=(x.^2).';  % parabola with 100 data points

M=21;  % polynomial degree
for j=1:M
    phi(:,j)=(x.').^(j-1);  % build matrix A
end

trials=[2 10 100];
for j=1:3    
    for jj=1:trials(j)
       f=(x.^2+0.2*randn(1,n)).';
       a1=pinv(phi)*f; f1=phi*a1; E1(jj)=norm(f-f1)/norm(f);
       a2=phi\f; f2=phi*a2; E2(jj)=norm(f-f2)/norm(f);
       [a3,stats]=lasso(phi,f,'Lambda',0.1); f3=phi*a3; E3(jj)=norm(f-f3)/norm(f);
       A1(:,jj)=a1; A2(:,jj)=a2; A3(:,jj)=a3;
    end
    A1m=mean(A1.'); A2m=mean(A2.'); A3m=mean(A3.');
    Err=[E1; E2; E3];
    
    subplot(3,3,j), bar(A1m), axis([0 21 -1 1.2])
    subplot(3,3,3+j), bar(A2m), axis([0 21 -1 1.2])
    subplot(3,3,6+j), bar(A3m), axis([0 21 -1 1.2])    
end


%subplot(3,3,j), bar(A1m,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis([0 21 -1 1.2])
%subplot(3,3,3+j), bar(A2m,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis([0 21 -1 1.2])
%subplot(3,3,6+j), bar(A3m,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis([0 21 -1 1.2])









%%
figure(2)

Atot=[A1m; A2m; A3m];  % average loadings of three methods
Atot2=(Atot>0.2).*Atot; % threshold
Atot3=[Atot; Atot2];    % combine both thresholded and not

figure(3), bar3(Atot.') 
figure(4), bar3(Atot2.') 

n=200; L=8;
x=linspace(0,L,n);
x1=x(1:100);   % train (interpolation)
x2=x(101:200); % test (extrapolation)

ftrain=(x1.^2).';  % interpolated parabola x=[0,4]
ftest=(x2.^2).';   % extrapolated parbola x=[4,5]

for j=1:M
    phi_i(:,j)=(x1.').^(j-1); % interpolation key
    phi_e(:,j)=(x2.').^(j-1); % extrapolation key
end

for jj=1:6 % compute inter/extra-polation scores
    ani=Atot3(jj,:).';
    fnai=phi_i*ani;
    Eni(jj)=norm(ftrain-fnai)/norm(ftrain);
    fnae=phi_e*ani;
    Ene(jj)=norm(ftest-fnae)/norm(ftest);
end

figure(5)
subplot(3,2,1), bar(Eni)
subplot(3,2,2), bar(Ene)

subplot(3,2,3), bar(Eni), axis([0 7 0 0.01])
subplot(3,2,4), bar(Ene), axis([0 7 0 0.1])

figure(3)
legend('','','','Location','NorthEast')
legend boxoff

%% Dendrograms




