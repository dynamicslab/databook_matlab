clear all, close all, clc
%% Create a simple signal with two frequencies
dt = .001;
t = 0:dt:1;
f = sin(2*pi*50*t) + sin(2*pi*120*t); % Sum of 2 frequencies
f = f + 2.5*randn(size(t));  %  Add some noise

%% Compute the Fast Fourier Transform FFT
n = length(t);
fhat = fft(f,n);       % Compute the fast Fourier transform
PSD = fhat.*conj(fhat)/n; % Power spectrum (power per freq)
freq = 1/(dt*n)*(0:n); % Create x-axis of frequencies in Hz
L = 1:floor(n/2);   % Only plot the first half of freqs

%% Use the PSD to filter out noise
indices = PSD>100;  % Find all freqs with large power
PSDclean = PSD.*indices;  % Zero out all others
fhat = indices.*fhat;  % Zero out small Fourier coeffs. in Y
ffilt = ifft(fhat); % Inverse FFT for filtered time signal

%% PLOTS
subplot(3,1,1)
plot(t,f,'r','LineWidth',1.2), hold on
plot(t,f,'k','LineWidth',1.5)
legend('Noisy','Clean')

subplot(3,1,2)
plot(t,f,'k','LineWidth',1.5), hold on
plot(t,ffilt,'b','LineWidth',1.2)
legend('Clean','Filtered')

subplot(3,1,3)
plot(freq(L),PSD(L),'r','LineWidth',1.5), hold on
plot(freq(L),PSDclean(L),'-b','LineWidth',1.2)
legend('Noisy','Filtered')

% 
% %% PLOTS
% subplot(3,1,1)
% plot(t,y,'r','LineWidth',1.2)
% hold on
% plot(t,x,'k','LineWidth',1.5)
% axis([0 .25 -5 5])
% legend('Noisy','Clean')
% 
% subplot(3,1,2)
% plot(t,x,'k','LineWidth',1.5)
% hold on
% plot(t,yfilt,'b','LineWidth',1.2)
% axis([0 .25 -5 5])
% legend('Clean','Filtered')
% 
% subplot(3,1,3)
% plot(freq(L),PSD(L),'r','LineWidth',1.5)
% hold on
% plot(freq(L),PSDclean(L),'-b','LineWidth',1.2)
% legend('Noisy','Filtered')