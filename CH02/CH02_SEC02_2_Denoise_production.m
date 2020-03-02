clear all

%% create a simple signal with two frequencies
dt = .001;
t = 0:dt:1;
x = sin(2*pi*50*t) + sin(2*pi*120*t);
y = x + 2.5*randn(size(t));  %  add some noise



%% Compute the Fast Fourier Transform FFT
N = length(t);
Y = fft(y,N);  % computes the (fast) discrete fourier transform
PSD = Y.*conj(Y)/N;  % Power spectrum (how much power in each freq)
freq = 1/(dt*N)*(0:N);  %create the x-axis of frequencies in Hz
L = 1:floor(N/2);  % only plot the first half of freqs


%% Use the PSD to filter out noise
indices = PSD>100;   % Find all freqs with large power
PSDclean = PSD.*indices;  % Zero out all others

Y = indices.*Y;  % zero out small Fourier coefficients in Y
yfilt = ifft(Y);     % inverse FFT to get filtered time-domain signal


%% PLOTS
subplot(3,1,1)
plot(-1000,-1000,'k','LineWidth',1.5)
hold on
plot(-1000,-1000,'r','LineWidth',1.2)
plot(t,y,'r','LineWidth',1.2)
plot(t,x,'k','LineWidth',1.5)
axis([0 .25 -5 5])
legend('Clean','Noisy')
set(gca,'LineWidth',1.2,'FontSize',12)

subplot(3,1,3)
plot(t,x,'k','LineWidth',1.5)
hold on
plot(t,yfilt,'b','LineWidth',1.2)
axis([0 .25 -5 5])
legend('Clean','Filtered')
set(gca,'LineWidth',1.2,'FontSize',12)

subplot(3,1,2)
plot(freq(L),PSD(L),'r','LineWidth',1.5)
% xlabel('Frequency (Hz)')
hold on
plot(freq(L),PSDclean(L),'-b','LineWidth',1.2)
legend('Noisy','Filtered')
set(gca,'LineWidth',1.2,'FontSize',12)

set(gcf,'Position',[100 100 550 450])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/DENOISE');
