clear all, close all, clc
addpath('./utils');
load allFaces.mat
X = faces(:,1:nfaces(1));
[L,S] = RPCA(X);


%%
inds = [3 4 14 15 17 18 19 20 21 32 43];
for k=[3 4 14 15 17 18 19 20 21 32 43]
    k
    subplot(2,2,1)
    imagesc(reshape(X(:,k),192,168)), colormap gray
    subplot(2,2,3)
    imagesc(reshape(L(:,k),192,168)), colormap gray
    subplot(2,2,4)
    imagesc(reshape(S(:,k),192,168)), colormap gray
    pause
end