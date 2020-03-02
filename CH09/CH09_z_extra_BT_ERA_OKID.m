clear all
close all
load testSys

% numInputs = 2;
% numOutputs = 2;
% stateDimension = 100;
% sysFull = drss(stateDimension,numOutputs, numInputs);
% r = 10;  % reduced model order


%% exact balanced truncation
hvals = hsvd(sysFull);
figure
stairs(cumsum(hvals)/sum(hvals))
xlabel('Number of Hankel Singular Values')
ylabel('Cumulative Sum of HSVs')
sysBT = balred(sysFull,r);  % balanced truncation

%% Obtain impulse response of full system
[yFull,t] = impulse(sysFull,0:1:(r*5)+1);  
YY = permute(yFull,[2 3 1])
% for i=1:length(yFull)
%     YY(:,:,i) = yFull(i,:,:);
% end

%% compute random input simulation for OKID
% L = 200 % length of randominput
% uRandom = randn(numInputs,L);  % random forcing input
% % We use uRandom from file for reproduciblity
yRandom = lsim(sysFull,uRandom,1:L)';  % output of random forcing
yRandom = yRandom+0.*rand(size(yRandom));  % (optional) add noise

%% Compute ERA from impulse response
mco = floor((length(yFull)-1)/2);  % m_c = m_o
[Ar,Br,Cr,Dr,HSVs] = ERA(YY,mco,mco,numInputs,numOutputs,r);
sysERA = ss(Ar,Br,Cr,Dr,-1);

%% Compute OKID and then ERA
[H,M] = OKID(yRandom,uRandom,r);
mco = floor((length(H)-1)/2);  % m_c = m_o
[Ar,Br,Cr,Dr,HSVs] = ERA(H,mco,mco,numInputs,numOutputs,r);
sysERAOKID = ss(Ar,Br,Cr,Dr,-1);

%% Compute BPOD
[yFull,t,xFull] = impulse(sysFull,0:1:(r*5)+1);  
sysAdjoint = ss(sysFull.A',sysFull.C',sysFull.B',sysFull.D',-1);
[yAdjoint,t,xAdjoint] = impulse(sysAdjoint,0:1:(r*5)+1);
% not the fastest way to compute, but illustrative
% both xAdjoint and xFull are size m x n x 2
HBPOD = [];
% we start at 2 to avoid incorporating the D matrix
for i=2:size(xAdjoint,1)
    Hrow = [];
    for j=2:size(xFull,1)
        Ystar = permute(squeeze(xAdjoint(i,:,:)),[2 1]);        
        MarkovParameter = Ystar*squeeze(xFull(j,:,:));
        Hrow = [Hrow MarkovParameter];
    end
    HBPOD = [HBPOD; Hrow];
end
[U,Sig,V] = svd(HBPOD);
Xdata = [];
Ydata = [];
for i=2:size(xFull,1)  % we start at 2 to avoid incorporating the D matrix
    Xdata = [Xdata squeeze(xFull(i,:,:))];
    Ydata = [Ydata squeeze(xAdjoint(i,:,:))];
end
Phi = Xdata*V*Sig^(-1/2);
Psi = Ydata*U*Sig^(-1/2);
Ar = Psi(:,1:r)'*sysFull.a*Phi(:,1:r);
Br = Psi(:,1:r)'*sysFull.b;
Cr = sysFull.c*Phi(:,1:r);
Dr = sysFull.d;
sysBPOD = ss(Ar,Br,Cr,Dr,-1);

%% plot input/output pair for OKID
figure
subplot(1,2,1)
title('Inputs')
stairs(uRandom(1,:),'k')
hold on
stairs(uRandom(2,:),'r')
legend('In(1)','In(2)')
% xlabel('Time')
% ylabel('Amplitude')
subplot(1,2,2)
title('Outputs')
stairs(yRandom(1,:),'k')
hold on
stairs(yRandom(2,:),'r')
legend('Out(1)','Out(2)')
% xlabel('Time')
% ylabel('Amplitude')
set(gcf,'Position',[100 100 650 200])

%% Plot impulse responses for all methods
figure
[y1,t1] = impulse(sysFull,0:1:200,'k');
% h = findobj(gcf,'type','line');
% set(h,'linewidth',2);
[y2,t2] = impulse(sysBT,0:1:100,'r')
[y3,t3] = impulse(sysERA,0:1:100,'--b')
[y4,t4] = impulse(sysERAOKID,0:1:100,'--g')
[y5,t5] = impulse(sysBPOD,0:1:100,'m--')
subplot(2,2,1)
stairs(y1(:,1,1),'k','LineWidth',2);
hold on
stairs(y2(:,1,1),'r','LineWidth',1.2);
stairs(y3(:,1,1),'b-','LineWidth',1.);
stairs(y4(:,1,1),'g--','LineWidth',1.);
stairs(y5(:,1,1),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,2)
stairs(y1(:,1,2),'k','LineWidth',2);
hold on
stairs(y2(:,1,2),'r','LineWidth',1.2);
stairs(y3(:,1,2),'b-','LineWidth',1.);
stairs(y4(:,1,2),'g--','LineWidth',1.);
stairs(y5(:,1,2),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,3)
stairs(y1(:,2,1),'k','LineWidth',2);
hold on
stairs(y2(:,2,1),'r','LineWidth',1.2);
stairs(y3(:,2,1),'b-','LineWidth',1.);
stairs(y4(:,2,1),'g--','LineWidth',1.);
stairs(y5(:,2,1),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,4)
stairs(y1(:,2,2),'k','LineWidth',2);
hold on
stairs(y2(:,2,2),'r','LineWidth',1.2);
stairs(y3(:,2,2),'b-','LineWidth',1.);
stairs(y4(:,2,2),'g--','LineWidth',1.);
stairs(y5(:,2,2),'m--','LineWidth',1.);
set(gca,'XLim',[0 60]);
grid on
legend('Full model, n=100',['Balanced truncation, r=',num2str(r)],['ERA, r=',num2str(r)],['ERA/OKID, r=',num2str(r)],['BPOD, r=',num2str(r)])
% legend('100 dimensional model',[num2str(r),' mode balance trunctation'],[num2str(r),' mode ERA model'],[num2str(r),' mode OKID/ERA model'])
set(gcf,'Position',[100 100 650 375])