clear, clc, close all

wlen = 64;                         % window length (recomended to be power of 2),   choose it!
h = wlen/4;                        % hop size (recomended to be power of 2),        choose it!
k = 5*wlen;                        % overlap-add span
win = hamming(wlen, 'periodic');   % window,                                        choose it!
s = zeros(k, 1);

for k = 0:h:k-wlen
    indx = k+1:k+wlen;             % current window location
    s(indx) = s(indx) + win.^2;    % window overlap-add
    winp(indx) = win;              % for plot only
    plot(winp, 'ok')               % plot just this window
    hold on
end

W0 = sum(win.^2);                  % find W0
s = h*s/W0;                        % scale the window overlap-add
stem(s, 'r');                      % plot window overlap-add