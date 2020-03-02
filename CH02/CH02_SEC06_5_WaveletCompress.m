clear all, close all, clc
A = imread('../../CH01_SVD/DATA/dog.jpg');
B = rgb2gray(A);

%% Wavelet Compression
[C,S] = wavedec2(B,4,'db1');
Csort = sort(abs(C(:))); % Sort by magnitude

for keep =  [.1 .05 .01 .005]
    thresh = Csort(floor((1-keep)*length(Csort)));
    ind = abs(C)>thresh;
    Cfilt = C.*ind;      % Threshold small indices
    
    % Plot Reconstruction
    Arecon=uint8(waverec2(Cfilt,S,'db1'));
    figure, imagesc(uint8(Arecon))
end