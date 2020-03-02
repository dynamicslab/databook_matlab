clear all, close all, clc
load testSys;  % previously saved system

q = 2;   % Number of inputs
p = 2;   % Number of outputs
n = 100; % State dimension
sysFull = drss(n,p,q); % Discrete random system
r = 10;  % Reduced model order

%% Plot Hankel singular values
hsvs = hsvd(sysFull); % Hankel singular values
figure
subplot(1,2,1)
semilogy(hsvs,'k','LineWidth',2)
hold on, grid on
semilogy(r,hsvs(r),'ro','LineWidth',2)
ylim([10^(-15) 100])
subplot(1,2,2)
plot(0:length(hsvs),[0; cumsum(hsvs)/sum(hsvs)],'k','LineWidth',2)
hold on, grid on
plot(r,sum(hsvs(1:r))/sum(hsvs),'ro','LineWidth',2)
set(gcf,'Position',[1 1 550 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/FIG_BT_HSVS');

%% Exact balanced truncation
sysBT = balred(sysFull,r);  % Balanced truncation

%% Compute BPOD
[yFull,t,xFull] = impulse(sysFull,0:1:(r*5)+1);  
sysAdj = ss(sysFull.A',sysFull.C',sysFull.B',sysFull.D',-1);
[yAdj,t,xAdj] = impulse(sysAdj,0:1:(r*5)+1);
% Not the fastest way to compute, but illustrative
% Bot xAdj and xFull are size m x n x 2
HankelOC = [];  % Compute Hankel matrix H=OC
for i=2:size(xAdj,1) % start at 2 to avoid the D matrix
    Hrow = [];
    for j=2:size(xFull,1)
        Ystar = permute(squeeze(xAdj(i,:,:)),[2 1]);        
        MarkovParameter = Ystar*squeeze(xFull(j,:,:));
        Hrow = [Hrow MarkovParameter];
    end
    HankelOC = [HankelOC; Hrow];
end
[U,Sig,V] = svd(HankelOC);
Xdata = [];
Ydata = [];
for i=2:size(xFull,1)  % start at 2 to avoid the D matrix
    Xdata = [Xdata squeeze(xFull(i,:,:))];
    Ydata = [Ydata squeeze(xAdj(i,:,:))];
end
Phi = Xdata*V*Sig^(-1/2);
Psi = Ydata*U*Sig^(-1/2);
Ar = Psi(:,1:r)'*sysFull.a*Phi(:,1:r);
Br = Psi(:,1:r)'*sysFull.b;
Cr = sysFull.c*Phi(:,1:r);
Dr = sysFull.d;
sysBPOD = ss(Ar,Br,Cr,Dr,-1);

%% Plot impulse responses for all methods
figure
impulse(sysFull,0:1:60), hold on;
impulse(sysBT,0:1:60)
impulse(sysBPOD,0:1:60)
legend('Full model, n=100','Balanced truncation, r=10','Balanced POD, r=10')

%% Plot impulse responses for all methods
figure
[y1,t1] = impulse(sysFull,0:1:200);
[y2,t2] = impulse(sysBT,0:1:100)
[y5,t5] = impulse(sysBPOD,0:1:100)
subplot(2,2,1)
stairs(y1(:,1,1),'LineWidth',2);
hold on
stairs(y2(:,1,1),'LineWidth',1.2);
stairs(y5(:,1,1),'LineWidth',1.);
ylabel('y_1')
title('u_1')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,2)
stairs(y1(:,1,2),'LineWidth',2);
hold on
stairs(y2(:,1,2),'LineWidth',1.2);
stairs(y5(:,1,2),'LineWidth',1.);
title('u_2')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,3)
stairs(y1(:,2,1),'LineWidth',2);
hold on
stairs(y2(:,2,1),'LineWidth',1.2);
stairs(y5(:,2,1),'LineWidth',1.);
xlabel('t')
ylabel('y_2')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,4)
stairs(y1(:,2,2),'LineWidth',2);
hold on
stairs(y2(:,2,2),'LineWidth',1.2);
stairs(y5(:,2,2),'LineWidth',1.);
xlabel('t')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,2)
legend('Full model, n=100',['Balanced truncation, r=',num2str(r)],['Balanced POD, r=',num2str(r)])
set(gcf,'Position',[100 100 550 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/FIG_BT_IMPULSE');