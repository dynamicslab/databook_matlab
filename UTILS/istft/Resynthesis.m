clear, clc, close all

% music program (stochastic non-stationary signal)
[x, fs] = wavread('track.wav');     
x = x(:, 1);                       
xmax = max(abs(x));                 
x = x/xmax; 

% signal parameters
xlen = length(x);                   
t = (0:xlen-1)/fs;                  

% define analysis and synthesis parameters
wlen = 1024;
h = wlen/4;
nfft = wlen;

% perform time-frequency analysis and resynthesis of the original signal
[stft, f, t_stft] = stft(x, wlen, h, nfft, fs);
[x_istft, t_istft] = istft(stft, h, nfft, fs);

% plot the original signal
figure(1)
plot(t, x, 'b')
grid on
xlim([0 max(t)])
ylim([-1.1 1.1])
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
xlabel('Time, s')
ylabel('Normalized amplitude')
title('Original and reconstructed signal')

% plot the resynthesized signal 
hold on
plot(t_istft, x_istft, '-.r')
legend('Original signal', 'Reconstructed signal')