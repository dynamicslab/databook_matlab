clear all, close all, clc
load ../../CH01_SVD/DATA/allFaces.mat
mustache = double(rgb2gray(imread('mustache.jpg'))/255);


%% Build Training and Test sets
Training = zeros(size(faces,1),30*20);
Test = zeros(size(faces,1),20*20);
for k=1:20
    baseind = 0;
    if(k>1) baseind = sum(nfaces(1:k-1));
    end
%     inds = baseind + randperm(nfaces(k));
    inds = baseind + (1:nfaces(k));
    Training(:,(k-1)*30+1:k*30) = faces(:,inds(1:30));
    Test(:,(k-1)*20+1:k*20) = faces(:,inds(31:50));       
end

%% Oclude test image (image 6 of test set for person 7)
% 126 = 6 + 20*(7-1);
% b1 - clean test image
b1 = Test(:,126);  
% b2 - mustache disguise
b2 = Test(:,126).*reshape(mustache,n*m,1);
randvec = randperm(n*m);
first40 = randvec(1:floor(.3*length(randvec)));
vals40 = uint8(255*rand(size(first40)));
b3 = b1;
b3(first40) = vals40;
% imagesc(reshape(b3,n,m)), colormap gray
b4 = b1 + 50*randn(size(b1));
imagesc(reshape(b4,n,m)), colormap gray

B = [b1 b2 b3 b4];
for k=1:4
    axes('position',[0  0  1  1])
    imagesc(reshape(B(:,k),n,m)), colormap gray
    axis off
    set(gcf,'Position',[100 100 168*2 192*2])
    set(gcf,'PaperPositionMode','auto')
%     print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b',num2str(k)]);
end
%% DOWNSAMPLE ALL IMAGES
M = size(Training,2);

TrainingSmall = zeros(120,M);
for k=1:M
    temp = reshape(Training(:,k),n,m);
%     tempSmall = temp(16:16:end,16:16:end);
    tempSmall = imresize(temp,[12 10],'lanczos3');
    TrainingSmall(:,k) = reshape(tempSmall,120,1);
end

Bsmall = zeros(120,4);
for k=1:4    
    temp = reshape(B(:,k),n,m);
%     tempSmall = temp(16:16:end,16:16:end);
    tempSmall = imresize(temp,[12 10],'lanczos3');
    Bsmall(:,k) = reshape(tempSmall,120,1);
end

% RENORMALIZE COLUMNS OF TRAINING SMALL

for k=1:M
    scalingFactor(k) = norm(TrainingSmall(:,k));
    TrainingSmall(:,k) = TrainingSmall(:,k)/scalingFactor(k);
end

for k=1:4
    axes('position',[0  0  1  1])
    imagesc(reshape(Bsmall(:,k),12,10)), colormap gray
    axis off
    set(gcf,'Position',[100 100 168 192])
    set(gcf,'PaperPositionMode','auto')
%     print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_bsmall',num2str(k)]);
end

%% L1 SEARCH, TESTCLEAN
b1s = Bsmall(:,1);
eps = .01;
cvx_begin;
    variable a1(M);                 % alph is slope of fit to be optimized 
    minimize( norm(a1,1) );
    subject to
        norm(TrainingSmall*a1 - b1s,2) < eps;
cvx_end;

figure
plot(a1,'k')
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRCa1');

figure
axes('position',[0  0  1  1])
imagesc(reshape(Training*(a1./scalingFactor'),n,m)), colormap gray
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b1L']);

imagesc(reshape(b1-(Training*(a1./scalingFactor')),n,m)), colormap gray
caxis([0 255])
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b1S']);

figure
binnedError = zeros(20,1);
for k=1:20
    L = (k-1)*30+1:k*30;
    binnedError(k) = norm(b1-(Training(:,L)*(a1(L)./scalingFactor(L)')))/norm(b1)
end
bar(binnedError,'FaceColor',[.7 .7 .7])
hold on
bar(7,binnedError(7),'FaceColor',[.7 0 0])
box on
xlim([0 21])
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRChistogram_b1');


%% L1 SEARCH, MUSTACHE
b2s = Bsmall(:,2);
eps = 500;
cvx_begin;
    variable a2(M);                 % alph is slope of fit to be optimized 
    minimize( norm(a2,1) );
    subject to
        norm(TrainingSmall*a2 - b2s,2) < eps;
cvx_end;

figure
plot(a2,'k')
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRCa2');

figure
axes('position',[0  0  1  1])
imagesc(reshape(Training*(a2./scalingFactor'),n,m)), colormap gray
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b2L']);

imagesc(reshape(b2-(Training*(a2./scalingFactor')),n,m)), colormap gray
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b2S']);

binnedError = zeros(20,1);
for k=1:20
    L = (k-1)*30+1:k*30;
    binnedError(k) = norm(b2-(Training(:,L)*(a2(L)./scalingFactor(L)')))/norm(b2)
end
bar(binnedError,'FaceColor',[.7 .7 .7])
hold on
bar(7,binnedError(7),'FaceColor',[.7 0 0])
box on
xlim([0 21])
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRChistogram_b2');

%% L1 SEARCH, OCCLUSION
b3s = Bsmall(:,3);
eps = 1000;
cvx_begin;
    variable a3(M);                 % alph is slope of fit to be optimized 
    minimize( norm(a3,1) );
    subject to
        norm(TrainingSmall*a3 - b3s,2) < eps;
cvx_end;

figure
plot(a3,'k')
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRCa3');

figure
axes('position',[0  0  1  1])
imagesc(reshape(Training*(a3./scalingFactor'),n,m)), colormap gray
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b3L']);

imagesc(reshape(b3-(Training*(a3./scalingFactor')),n,m)), colormap gray
caxis([0 255])
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b3S']);

binnedError = zeros(20,1);
for k=1:20
    L = (k-1)*30+1:k*30;
    binnedError(k) = norm(b3-(Training(:,L)*(a3(L)./scalingFactor(L)')))/norm(b3)
end
bar(binnedError,'FaceColor',[.7 .7 .7])
hold on
bar(7,binnedError(7),'FaceColor',[.7 0 0])
box on
xlim([0 21])
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRChistogram_b3');

%% L1 SEARCH, NOISE
b4s = Bsmall(:,4);
eps = 10;
cvx_begin;
    variable a4(M);                 % alph is slope of fit to be optimized 
    minimize( norm(a4,1) );
    subject to
        norm(TrainingSmall*a4 - b4s,2) < eps;
cvx_end;

figure
plot(a4,'k')
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRCa4');

figure
axes('position',[0  0  1  1])
imagesc(reshape(Training*(a4./scalingFactor'),n,m)), colormap gray
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b4L']);

imagesc(reshape(b4-(Training*(a4./scalingFactor')),n,m)), colormap gray
caxis([0 255])
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b4S']);

binnedError = zeros(20,1);
for k=1:20
    L = (k-1)*30+1:k*30;
    binnedError(k) = norm(b4-(Training(:,L)*(a4(L)./scalingFactor(L)')))/norm(b4)
end
bar(binnedError,'FaceColor',[.7 .7 .7])
hold on
bar(7,binnedError(7),'FaceColor',[.7 0 0])
box on
xlim([0 21])
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRChistogram_b4');


%% LEAST SQUARES IS NO GOOD

a4L2 = pinv(Training)*b4;
figure
plot(a4L2,'k')
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRCa4L2');

figure
axes('position',[0  0  1  1])
imagesc(reshape(Training*a4L2,n,m)), colormap gray
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b4L_L2']);

imagesc(reshape(b4-(Training*a4),n,m)), colormap gray
% caxis([0 255])
axis off
set(gcf,'Position',[100 100 168*2 192*2])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_b4S_L2']);



binnedError = zeros(20,1);
for k=1:20
    L = (k-1)*30+1:k*30;
    binnedError(k) = norm(b4-(Training(:,L)*(a4L2(L))))/norm(b4)
end
bar(binnedError,'FaceColor',[.7 .7 .7])
xlim([0 21])
set(gcf,'Position',[100 100 300 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_ex06_SRChistogram_b4L2');

%%  PLOT LIBRARY AND TEST SAMPLE
figure
axes('position',[0  0  1  1])
imagesc(TrainingSmall), colormap gray
axis off
set(gcf,'Position',[100 100 1200 240])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_LIBRARYSMALL']);

imagesc((b1s)), colormap gray, axis off
caxis([0 255])
set(gcf,'Position',[100 100 50 900])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_TESTIMAGE']);

axes('position',[0  0  1  1])

imagesc((450-a1')), colormap gray, axis off
caxis([0 550])
set(gcf,'Position',[1 1 1440 50])
set(gcf,'PaperPositionMode','auto')
% print('-dpng','-r0','-loose', ['../figures/f_chCS_EX06SRC_TESTSPARSE']);