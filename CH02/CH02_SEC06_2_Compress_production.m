clear all, close all, clc
A = imread('../../CH01_SVD/DATA/dog.jpg');
B = rgb2gray(A);

%% FFT Compression
figure
Bt=fft2(B);
Btsort = sort(abs(Bt(:)));  % Sort by magnitude

% Zero out all small coefficients and inverse transform
percentvec = [.1 .05 .01 .002];
for k=1:4
    keep = percentvec(k);
    thresh = Btsort(floor((1-keep)*length(Btsort)));
    ind = abs(Bt)>thresh;
    Atlow = Bt.*ind;        % Threshold small indices
    Flow = log(abs(fftshift(Atlow))+1); % put FFT on log-scale
    imshow(mat2gray(Flow),[]);
    
    % Plot Reconstruction
    Alow=uint8(ifft2(Atlow));
    imshow(Alow)
    
    axis off
    set(gcf,'PaperPositionMode','auto')
    %     print('-depsc2', '-loose', ['../figures/2DFFT_Compress',num2str(k)]);
%     print('-dpng', '-loose', ['../figures/2DFFT_Compress',num2str(k)]);
    
end