% Compressed Sensing Examples
% Copyright Brunton, Kutz, Proctor, 2016, All Rights Reserved
% Code by Steven L. Brunton (sbrunton@uw.edu)

clear all, close all, clc;
%% Generate signal, DCT of signal
n = 4096;    % points in high resolution signal
t = linspace(0, 1, n); 
x = cos(2* 97 * pi * t) + cos(2* 777 * pi * t); 
xt = fft(x); % Fourier transformed signal
PSD = xt.*conj(xt)/n;  % Power spectral density

%% Randomly sample signal
p = 128; % num. random samples, p=n/32
perm = round(rand(p, 1) * n);
y = x(perm); % compressed measurement

%% Solve compressed sensing problem
Psi = dct(eye(n, n));  % build Psi
Theta = Psi(perm, :);  % Measure rows of Psi

s = cosamp(Theta,y',10,1.e-10,10); % CS via matching pursuit
xrecon = idct(s);      % reconstruct full signal

%% Plot
time_window = [1024 1280]/4096;

figure
subplot(2,2,2)
freq = n/(n)*(0:n);  %create the x-axis of frequencies in Hz
L = 1:floor(n/2);  % only plot the first half of freqs
plot(freq(L),PSD(L),'k', 'LineWidth', 2);
axis([0 1024 0 1200]);

subplot(2,2,1)
plot(t, x, 'k', 'LineWidth', 2);
hold on
plot(perm/n,y,'rx','LineWidth',3);
axis([time_window -2 2]);

subplot(2,2,3)
plot(t, xrecon, 'r', 'LineWidth', 2);
ylim([-2 2])
axis([time_window -2 2]);

subplot(2,2,4)
xtrecon = fft(xrecon,n);  % computes the (fast) discrete fourier transform
PSDrecon = xtrecon.*conj(xtrecon)/n;  % Power spectrum (how much power in each freq)
plot(freq(L),PSDrecon(L),'r', 'LineWidth', 2);
axis([0 1024 0 1200]);

set(gcf,'Position',[100 100 600 400])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex02_audio');


%% L1-Minimization using CVX
cvx_begin;
    variable s(n); 
    minimize( norm(s,1) ); 
    subject to 
        Theta*s == y';
cvx_end;


% 
% %% De-bias
% ind = find(abs(s)>10)          % find active Fourier modes
% xvals = Theta(:,ind)\y';  % regress onto sparse coefficients
% s = zeros(size(s));
% s(ind) = xvals;
% xrecon = idct(s);
% 
% figure
% subplot(2,2,2)
% N = length(t);
% xt = fft(x,N);  % computes the (fast) discrete fourier transform
% PSD = xt.*conj(xt)/N;  % Power spectrum (how much power in each freq)
% freq = n/(N)*(0:N);  %create the x-axis of frequencies in Hz
% L = 1:floor(N/2);  % only plot the first half of freqs
% plot(freq(L),PSD(L),'k', 'LineWidth', 2);
% xlim([0 1024]);
% 
% subplot(2,2,1)
% plot(t, x, 'k', 'LineWidth', 2);
% hold on
% plot(perm/n,y,'rx','LineWidth',3);
% xlim(time_window);
% 
% subplot(2,2,3)
% plot(t, xrecon, 'r', 'LineWidth', 2);
% ylim([-2 2])
% xlim(time_window);
% xlabel('Time (s)')
% 
% subplot(2,2,4)
% xt = fft(xrecon,N);  % computes the (fast) discrete fourier transform
% PSD = xt.*conj(xt)/N;  % Power spectrum (how much power in each freq)
% plot(freq(L),PSD(L),'r', 'LineWidth', 2);
% xlabel('Frequency (Hz)');
% axis([0 1024 0 1000]);