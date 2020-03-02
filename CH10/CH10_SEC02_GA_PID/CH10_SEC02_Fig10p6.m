clear all, close all, clc
L = 2;
dx = .25;
[X,Y,Z] = meshgrid(-L:dx:L,-L:dx:L,-L:dx:L);
V = randn(size(X));

Vstruct = peaks(size(X,1));
V(1,:,:) = squeeze(V(1,:,:)) + Vstruct;
V(:,1,:) = squeeze(V(:,1,:)) + 1.5*flipud(Vstruct);
V(:,:,end) = squeeze(V(:,:,end)) + fliplr(flipud(Vstruct));

Sx = -L;
Sy = -L;
Sz = L;
figure
slice(X,Y,Z,V,Sx,Sy,Sz)

axis([-L,L,-L,L,-L,L])
xtickvals = [-L:2*dx:L];
set(gca,'XTick',xtickvals,'YTick',xtickvals,'ZTick',xtickvals);
set(gca,'XTickLabels',{},'YTickLabels',{},'ZTickLabels',{});
set(gca,'LineWidth',1.5)
daspect([1,1,1])
hold on
shading interp
lighting phong
box on
grid on

plot3(squeeze(X(1,1:2:end,1:2:end)),squeeze(Y(1,1:2:end,1:2:end)),squeeze(Z(1,1:2:end,1:2:end)),'k','LineWidth',1)
plot3(squeeze(Z(1,1:2:end,1:2:end)),squeeze(Y(1,1:2:end,1:2:end)),squeeze(X(1,1:2:end,1:2:end)),'k','LineWidth',1)

plot3(squeeze(X(1:2:end,1,1:2:end)),squeeze(Z(1:2:end,1,1:2:end)),squeeze(Y(1:2:end,1,1:2:end)),'k','LineWidth',1)
plot3(squeeze(X(1:2:end,1,1:2:end)),squeeze(Y(1:2:end,1,1:2:end)),squeeze(Z(1:2:end,1,1:2:end)),'k','LineWidth',1)

plot3(squeeze(X(1:2:end,1:2:end,1)),squeeze(Y(1:2:end,1:2:end,1)),squeeze(Z(1:2:end,1:2:end,end)),'k','LineWidth',1)
plot3(squeeze(Y(1:2:end,1:2:end,1)),squeeze(X(1:2:end,1:2:end,1)),squeeze(Z(1:2:end,1:2:end,end)),'k','LineWidth',1)

colormap hot

set(gcf,'Position',[100 100 375 400])
set(gcf,'PaperPositionMode','auto')
print('-dpng', '-loose', '../figures/GA_PID_CUBE');
