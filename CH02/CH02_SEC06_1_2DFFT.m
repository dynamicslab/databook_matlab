clear all, close all, clc
A = imread('../../CH01_SVD/DATA/dog.jpg');
B = rgb2gray(A);    % Convert to grayscale image
subplot(1,3,1), imagesc(B);         % Plot image

for j=1:size(B,1);  % Compute row-wise FFT
    Cshift(j,:) = fftshift(fft(B(j,:)));
    C(j,:) = (fft(B(j,:)));
end
subplot(1,3,2), imagesc(log(abs(Cshift)))

for j=1:size(C,2);  % Compute column-wise FFT
    D(:,j) = fft(C(:,j));
end
subplot(1,3,3), imagesc(fftshift(log(abs(D))))

D = fft2(B); % Much more efficient to use fft2