clear all, close all, clc

t = (-3:.01:3)';

Utrue = [cos(17*t).*exp(-t.^2) sin(11*t)];
Strue = [2 0; 0 .5];
Vtrue = [sin(5*t).*exp(-t.^2) cos(13*t)];

X = Utrue*Strue*Vtrue';
figure, imshow(X);

%%
sigma = 1;
Xnoisy = X+sigma*randn(size(X));
figure, imshow(Xnoisy);

%%
[U,S,V] = svd(Xnoisy);

N = size(Xnoisy,1);
cutoff = (4/sqrt(3))*sqrt(N)*sigma; % Hard threshold
r = max(find(diag(S)>cutoff)); % Keep modes w/ sig > cutoff
Xclean = U(:,1:r)*S(1:r,1:r)*V(:,1:r)';
figure, imshow(Xclean)

%%
cdS = cumsum(diag(S))./sum(diag(S));  % Cumulative energy
r90 = min(find(cdS>0.90));  % Find r to capture 90% energy

X90 = U(:,1:r90)*S(1:r90,1:r90)*V(:,1:r90)';
figure, imshow(X90)

%% plot singular values
figure
semilogy(diag(S),'-ok','LineWidth',1.5)
hold on, grid on
semilogy(diag(S(1:r,1:r)),'or','LineWidth',1.5)
plot([-20 N+20],[cutoff cutoff],'r--','LineWidth',2)
axis([-10 610 .003 300])
rectangle('Position',[-5,20,100,200],'LineWidth',2,'LineStyle','--')
     
figure
semilogy(diag(S),'-ok','LineWidth',1.5)
hold on, grid on
semilogy(diag(S(1:r,1:r)),'or','LineWidth',1.5)
plot([-20 N+20],[cutoff cutoff],'r--','LineWidth',2)
axis([-5 100 20 200])
     
figure
plot(cdS,'-ok','LineWidth',1.5)
hold on, grid on
plot(cdS(1:r90),'ob','LineWidth',1.5)
plot(cdS(1:r),'or','LineWidth',1.5)
set(gca,'XTick',[0 300 r90 600],'YTick',[0 .5 0.9 1.0])
xlim([-10 610])
plot([r90 r90 -10],[0 0.9 0.9],'b--','LineWidth',1.5)