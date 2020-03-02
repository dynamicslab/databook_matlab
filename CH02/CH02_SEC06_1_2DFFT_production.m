clear all, close all, clc
A = imread('../../CH01_SVD/DATA/dog.jpg');
B = rgb2gray(A);

for j=1:size(B,1);
    Cshift(j,:) = fftshift(fft(B(j,:)));
    C(j,:) = (fft(B(j,:)));
end

for j=1:size(C,2);
    D(:,j) = fft(C(:,j));
end

subplot(1,3,1)
imagesc(B);
subplot(1,3,2)
imagesc(log(abs(Cshift)))
subplot(1,3,3)
imagesc(fftshift(log(abs(D))))
colormap gray
%%
figure
imagesc(B)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/2DFFTa');

figure
imagesc(log(abs(Cshift)))
colormap gray

axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/2DFFTb');
figure
imagesc(fftshift(log(abs(D))))
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/2DFFTc');

%% FFT Compression
figure
Bt=fft2(B);
F = log(abs(fftshift(Bt))+1);  % put FFT on log-scale

% Zero out all small coefficients and inverse transform
Btsort = sort(abs(Bt(:)));
keepvec = [.1 .05 .01 .005 .002 .001];
for k=4:6
    keep = keepvec(k);
    % keep = 0.05;
    thresh = Btsort(floor((1-keep)*length(Btsort)));
    ind = abs(Bt)>thresh;
    Atlow = Bt.*ind;
    Flow = log(abs(fftshift(Atlow))+1);  % put FFT on log-scale
    imshow(mat2gray(Flow),[]);
    
    % Plot Reconstruction
    Alow=uint8(ifft2(Atlow));
    imshow(Alow)
    
    axis off
    set(gcf,'PaperPositionMode','auto')
    %     print('-depsc2', '-loose', ['../figures/2DFFT_Compress',num2str(k)]);
    print('-dpng', '-loose', ['../figures/2DFFT_Compress',num2str(k)]);
    
end

%% Denoise
B = Bold(2:2:end,2:2:end);
ind = rand(size(B));
Bnoise = B + uint8(200*randn(size(B)));
% Bnoise = B + uint8(200*rand(size(B)));
% Bnoise = B.*uint8(ind<.2);
imagesc(Bnoise)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise1');

Bt=fft2(Bnoise);
Btshift = fftshift(Bt);
[nx,ny] = size(B);

figure
F = log(abs(Btshift)+1);  % put FFT on log-scale
imagesc(F)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise2');

[X,Y] = meshgrid(-ny/2+1:ny/2,-nx/2+1:nx/2);
R2 = X.^2+Y.^2;
ind = R2<150^2;
Btshiftfilt = Btshift.*ind;

figure
Ffilt = log(abs(Btshiftfilt)+1);  % put FFT on log-scale
imagesc(Ffilt)
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise3');

figure
Btfilt = ifftshift(Btshiftfilt);
Bfilt = ifft2(Btfilt);
imagesc(uint8(Bfilt))
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
% print('-dpng', '-loose', '../figures/2DFFT_Noise4');

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

