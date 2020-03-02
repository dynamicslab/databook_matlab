clear all, close all, clc

% Define spatial domain
c = 2;              % Wave speed
L = 20;             % Length of domain 
N = 1000;           % Number of discretization points
dx = L/N;
x = -L/2:dx:L/2-dx; % Define x domain

% Define discrete wavenumbers
kappa = (2*pi/L)*[-N/2:N/2-1];
kappa = fftshift(kappa');    % Re-order fft wavenumbers

% Initial condition 
u0 = sech(x);        
uhat0 = fft(u0);

% Simulate in Fourier frequency domain
dt = 0.025;
t = 0:dt:100*dt;
[t,uhat] = ode45(@(t,uhat)rhsWave(t,uhat,kappa,c),t,uhat0);

% Alternatively, simulate in spatial domain
[t,u] = ode45(@(t,u)rhsWaveSpatial(t,u,kappa,c),t,u0);

% Inverse FFT to bring back to spatial domain
for k = 1:length(t)
    u(k,:) = ifft(uhat(k,:));
end

% Plot solution in time
subplot(1,2,1)
h=waterfall(real(u(1:10:end,:)));
set(h,'LineWidth',2,'FaceAlpha',.5);
colormap(jet/1.5)

subplot(1,2,2)
imagesc(flipud(real(u)));
colormap jet

%% FIGURES (PRODUCTION)
figure
CC = colormap(jet(101));
dt = 0.025;
for k = 1:length(t)
    u(k,:) = real(ifft(uhat(k,:)));
    if(mod(k-1,10)==0)
        plot(x,u(k,:),'Color',CC(k,:),'LineWidth',1.5)
        hold on, grid on, drawnow
    end   
end
% xlabel('Spatial variable, x')
% ylabel('Temperature, u(x,t)')
axis([-L/2 L/2 -.1 1.1])
set(gca,'LineWidth',1.2,'FontSize',12);
set(gcf,'Position',[100 100 550 220]);
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../../figures/FFTWave1');

%
figure
subplot(1,2,1)
h=waterfall(u(1:10:end,:));
set(h,'LineWidth',2,'FaceAlpha',.5);
colormap(jet/1.5)
% view(22,29)
view(3,21)
set(gca,'LineWidth',1.5)
set(gca,'XTick',[0 500 1000],'XTickLabels',{})
set(gca,'ZTick',[0 .5 1],'ZTickLabels',{})
set(gca,'YTick',[0 5 10],'YTickLabels',{})

subplot(1,2,2)
imagesc(flipud(u));
set(gca,'LineWidth',1.5)
set(gca,'XTick',[0 500 1000],'XTickLabels',{})
set(gca,'YTick',[0 50 100],'YTickLabels',{})

colormap jet
set(gcf,'Position',[100 100 600 250])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../../figures/FFTWave2');