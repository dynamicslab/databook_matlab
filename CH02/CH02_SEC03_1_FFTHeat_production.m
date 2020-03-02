clear all, close all, clc
a = 1;        % Thermal diffusivity constant
L = 100;      % Length of domain
N = 1000;     % Number of discretization points
dx = L/N;
x = -L/2:dx:L/2-dx; % Define x domain

% Define discrete wavenumbers
kappa = (2*pi/L)*[-N/2:N/2-1];
kappa = fftshift(kappa);    % Re-order fft wavenumbers

% Initial condition
u0 = 0*x;
u0((L/2 - L/10)/dx:(L/2 + L/10)/dx) = 1;

% Simulate in Fourier frequency domain
t = 0:0.1:10;
[t,uhat]=ode45(@(t,uhat)rhsHeat(t,uhat,kappa,a),t,fft(u0));

for k = 1:length(t) % iFFT to return to spatial domain
    u(k,:) = ifft(uhat(k,:));
end


% Plot solution in time
subplot(1,2,1)
h=waterfall((u(1:10:end,:)));
set(h,'LineWidth',2,'FaceAlpha',.5);
colormap(jet/1.5)

subplot(1,2,2)
imagesc(flipud(u));
colormap jet
%% FIGURES (PRODUCTION)
figure
CC = colormap(jet(100));
dt = 0.1;
for k = 1:100
    u(k,:) = ifft(uhat(k,:));
    if(mod(k-1,10)==0)
        plot(x,u(k,:),'Color',CC(k,:),'LineWidth',1.5)
        hold on, grid on, drawnow
    end   
end
% xlabel('Spatial variable, x')
% ylabel('Temperature, u(x,t)')
axis([-50 50 -.1 1.1])
set(gca,'LineWidth',1.2,'FontSize',12);
set(gcf,'Position',[100 100 550 220]);
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../../figures/FFTHeat1');

%
figure
subplot(1,2,1)
h=waterfall(u(1:10:end,:));
set(h,'LineWidth',2,'FaceAlpha',.5);
colormap(jet/1.5)
view(22,29)
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
% print('-depsc2', '-loose', '../../figures/FFTHeat2');