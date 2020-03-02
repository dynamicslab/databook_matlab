clear all, close all, clc
A = imread('../../CH01_SVD/DATA/dog.jpg');
B = rgb2gray(A);

%% Wavelet Compression
figure
[C,S] = wavedec2(B,4,'db1');

% Zero out all small coefficients and inverse transform
Csort = sort(abs(C(:)));
keepvec = [.1 .05 .01 .005 .002 .001];
for k=1:6
    figure
    keep = keepvec(k);
    % keep = 0.05;
    thresh = Csort(floor((1-keep)*length(Csort)));
    ind = abs(C)>thresh;
    Cfilt = C.*ind;
    
    % Plot Reconstruction
    Alow=uint8(waverec2(Cfilt,S,'db1'));
    imagesc(uint8(Alow))
    colormap gray
    
    colormap gray
    axis off
    axis tight
    set(gcf,'Position',[100 100 600 800])
    set(gcf,'PaperPositionMode','auto')
    %     print('-depsc2', '-loose', ['../figures/2DFFT_Compress',num2str(k)]);
        print('-dpng', '-loose', ['../figures/2DWavelet_Compress',num2str(k)]);
    
end