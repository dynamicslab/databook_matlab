clear all, close all, clc

% If you download mp3read, you can use this code
% also, need to download mp3read from 
% http://www.mathworks.com/matlabcentral/fileexchange/13852-mp3read-and-mp3write
% [Y,FS,NBITS,OPTS] = mp3read('../../DATA/beethoven.mp3'); % add in your own song
% T = 40;            % 40 seconds
% y=Y(1:T*FS);       % First 40 seconds
load ../../DATA/beethoven_40sec.mat 
%% Spectrogram
spectrogram(y,5000,400,24000,24000,'yaxis');

%% SPECTROGRAM 
% uncomment remaining code and download stft code by M.Sc. Eng. Hristo Zhivomirov
% wlen = 5000;
% h=400;        % Overlap is wlen - h
% % perform time-frequency analysis and resynthesis of the original signal
% [S, f, t_stft] = stft(y, wlen, h, FS/4, FS);  % y axis range goes up to 4000 HZ
% imagesc(log10(abs(S)));
% load CC.mat
% colormap(ones(size(CC))-(CC))
% 
% axis xy, hold on
% XTicks = [1 300 600 900 1200 1500 1800 2100];
% XTickLabels = {'0','5','10','15','20','25','30','35'};
% YTicks = [0 1000 2000 3000];
% YTickLabels = {'0','4000','8000','12000'};
% set(gca,'XTick',XTicks,'XTickLabels',XTickLabels);
% set(gca,'YTick',YTicks,'YTickLabels',YTickLabels);
% 
% % plot a frequency
% freq = @(n)(((2^(1/12))^(n-49))*440);
% freq(40) % frequency of 40th key = C