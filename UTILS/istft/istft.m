%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          Inverse Short-Time Fourier Transform        %
%               with MATLAB Implementation             %
%                                                      %
% Author: M.Sc. Eng. Hristo Zhivomirov       12/26/13  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [x, t] = istft(stft, h, nfft, fs)

% function: [x, t] = istft(stft, h, nfft, fs)
% stft - STFT matrix (only unique points, time across columns, freq across rows)
% h - hop size
% nfft - number of FFT points
% fs - sampling frequency, Hz
% x - signal in the time domain
% t - time vector, s

% estimate the length of the signal
coln = size(stft, 2);
xlen = nfft + (coln-1)*h;
x = zeros(1, xlen);

% form a periodic hamming window
win = hamming(nfft, 'periodic');

% perform IFFT and weighted-OLA
if rem(nfft, 2)                     % odd nfft excludes Nyquist point
    for b = 0:h:(h*(coln-1))
        % extract FFT points
        X = stft(:, 1 + b/h);
        X = [X; conj(X(end:-1:2))];
        
        % IFFT
        xprim = real(ifft(X));
        
        % weighted-OLA
        x((b+1):(b+nfft)) = x((b+1):(b+nfft)) + (xprim.*win)';
    end
else                                % even nfft includes Nyquist point
    for b = 0:h:(h*(coln-1))
        % extract FFT points
        X = stft(:, 1+b/h);
        X = [X; conj(X(end-1:-1:2))];
        
        % IFFT
        xprim = real(ifft(X));
        
        % weighted-OLA
        x((b+1):(b+nfft)) = x((b+1):(b+nfft)) + (xprim.*win)';
    end
end

W0 = sum(win.^2);                   % find W0
x = x.*h/W0;                        % scale the weighted-OLA

% calculate the time vector
actxlen = length(x);                % find actual length of the signal
t = (0:actxlen-1)/fs;               % generate time vector

end