clear all, close all, clc

kmax = 7;

dx = 0.001;
L = pi;
x = (-1+dx:dx:1)*L;
f = 0*x;
n = length(f);
nquart = floor(n/4);
nhalf = floor(n/2);

f(nquart:nhalf) = 4*(1:nquart+1)/n;
f(nhalf+1:3*nquart) = 1-4*(0:nquart-1)/n;
subplot(3,1,1)
plot(x,f,'-','Color',[0 0 0],'LineWidth',1.5)
ylim([-.2 1.5])
xlim([-1.25*L 1.25*L])
set(gca,'LineWidth',1.2)
set(gca,'XTick',[-L 0 L],'XTickLabels',{});%{'-L','0','L','2L'})
set(gca,'YTick',[0 1],'YTickLabels',{});
box off

CC = colormap(jet(8));
% CCsparse = CC(5:5:end,:);
% CCsparse(end+1,:) = CCsparse(1,:);
CCsparse = CC(1:3:end,:);
%
subplot(3,1,2)
L = pi;
A0 = sum(f.*ones(size(x)))*dx;
plot(x,A0+0*f,'-','Color',CC(1,:)*.8,'LineWidth',1.2);
hold on
fFS = A0/2;
for k=1:kmax
    A(k) = sum(f.*cos(pi*k*x/L))*dx;
    B(k) = sum(f.*sin(pi*k*x/L))*dx;
    plot(x,A(k)*cos(k*pi*x/L),'-','Color',CC(k,:)*.8,'LineWidth',1.2);
%     plot(x,B(k)*sin(2*k*pi*x/L),'k-','LineWidth',1.2);
    fFS = fFS + A(k)*cos(k*pi*x/L) + 0*B(k)*sin(k*pi*x/L);
end
ylim([-.7 .7])
xlim([-1.25*L 1.25*L])
set(gca,'LineWidth',1.2)
set(gca,'XTick',[-L 0 L],'XTickLabels',{});%{'-L','0','L','2L'})
set(gca,'YTick',[-.5 0 .5],'YTickLabels',{});
box off
% 
subplot(3,1,1)
hold on
plot(x,fFS,'-','Color',CC(7,:)*.8,'LineWidth',1.2)
l1=legend('     ','    ')
set(l1,'box','off');
l1.FontSize = 16;


subplot(3,1,3)
A0 = sum(f.*ones(size(x)))*dx;
plot(x,A0+0*f,'-','Color',CC(1,:),'LineWidth',1.2);
hold on
fFS = A0/2;
for k=1:7
    Ak = sum(f.*cos(pi*k*x/L))*dx;
    Bk = sum(f.*sin(pi*k*x/L))*dx;
    plot(x,Ak*cos(k*pi*x/L),'-','Color',CC(k,:)*.8,'LineWidth',1.2);
%     plot(x,Bk*sin(2*k*pi*x/L),'k-','LineWidth',1.2);
    fFS = fFS + Ak*cos(k*pi*x/L) + 0*Bk*sin(k*pi*x/L);
end
ylim([-.06 .06])
xlim([-1.25*L 1.25*L])
set(gca,'LineWidth',1.2)
set(gca,'XTick',[-L 0 L],'XTickLabels',{});%{'-L','0','L','2L'})
set(gca,'YTick',[-.05 0 .05],'YTickLabels',{});
box off

set(gcf,'Position',[100 100 550 400])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/FourierTransformSines');

%% Plot amplitudes
clear ERR
clear A
fFS = A0/2;
A(1) = A0/2;
ERR(1) = norm(f-fFS);
kmax = 100;
for k=1:kmax
    A(k+1) = sum(f.*cos(2*pi*k*x/L))*dx*2/L;
    B(k+1) = sum(f.*sin(2*pi*k*x/L))*dx*2/L;
%     plot(x,B(k)*sin(2*k*pi*x/L),'k-','LineWidth',1.2);
    fFS = fFS + A(k+1)*cos(2*k*pi*x/L) + 0*B(k+1)*sin(2*k*pi*x/L);
    ERR(k+1) = norm(f-fFS)/norm(f);
end
thresh = median(ERR)*sqrt(kmax)*4/sqrt(3);
r = max(find(ERR>thresh));
r = 7;
subplot(2,1,1)
semilogy(0:1:kmax,A,'k','LineWidth',1.5)
hold on
semilogy(r,A(r+1),'bo','LineWidth',1.5)
xlim([0 kmax])
ylim([10^(-7) 1])
subplot(2,1,2)
semilogy(0:1:kmax,ERR,'k','LineWidth',1.5)
hold on
semilogy(r,ERR(r+1),'bo','LineWidth',1.5)
xlim([0 kmax])
ylim([3*10^(-4) 20])
set(gcf,'Position',[100 100 500 300])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/FourierTransformSinesERROR');
