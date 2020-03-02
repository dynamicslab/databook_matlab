clear all, close all, clc
A = imread('../../CH01_SVD/DATA/dog.jpg');
B = rgb2gray(A);

%%
n = 2; w = 'db1'; [c,s] = wavedec2(B,n,w);
plotwavelet2(c,s,2,'db1',128,'square');
colormap gray
axis off
axis tight
set(gcf,'Position',[100 100 600 800])
set(gcf,'PaperPositionMode','auto')
print('-dpng', '-loose', '../figures/2DWavelet_Square');

%%
n = 3; w = 'sym2'; [c,s] = wavedec2(B,n,w);
[H1,V1,D1] = detcoef2('all',c,s,1);
A1 = appcoef2(c,s,'haar',1);
V1img = wcodemat(V1,255,'mat',1);
H1img = wcodemat(H1,255,'mat',1);
D1img = wcodemat(D1,255,'mat',1);
A1img = wcodemat(A1,255,'mat',1);
imagesc(A1img)
figure
[H2,V2,D2] = detcoef2('all',c,s,2);
A2 = appcoef2(c,s,'haar',2);
V2img = wcodemat(V2,255,'mat',2);
H2img = wcodemat(H2,255,'mat',2);
D2img = wcodemat(D2,255,'mat',2);
A2img = wcodemat(A2,255,'mat',2);
imagesc(V2img)
figure
colormap(gray); rv = length(gray);
plotwavelet2(c,s,3,'haar',rv,'square')

figure
subplot(2,2,1)
imagesc(A1img)

subplot(2,2,2)
imagesc(V1img)

subplot(2,2,3)
imagesc(H1img)

subplot(2,2,4)
imagesc(D1img)
