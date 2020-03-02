clear all, close all, clc

load ../DATA/allFaces.mat

% We use the first 36 people for training data
trainingFaces = faces(:,1:sum(nfaces(1:36)));
avgFace = mean(trainingFaces,2);  % size n*m by 1;

% compute eigenfaces on mean-subtracted training data
X = trainingFaces-avgFace*ones(1,size(trainingFaces,2));
[U,S,V] = svd(X,'econ');

figure, axes('position',[0  0  1  1]), axis off
imagesc(reshape(avgFace,n,m)), colormap gray

for i=1:50  % plot the first 50 eigenfaces
    pause(0.1);  % wait for 0.1 seconds
    imagesc(reshape(U(:,i),n,m)); colormap gray;
end



%% Now show eigenface reconstruction of image that was omitted from test set

testFace = faces(:,1+sum(nfaces(1:36))); % first face of person 37
axes('position',[0  0  1  1]), axis off
imagesc(reshape(testFace,n,m)), colormap gray

testFaceMS = testFace - avgFace;
for r=25:25:2275
    reconFace = avgFace + (U(:,1:r)*(U(:,1:r)'*testFaceMS));
    imagesc(reshape(reconFace,n,m)), colormap gray
    title(['r=',num2str(r,'%d')]);
    pause(0.1)
end


%% Project person 2 and 7 onto PC5 and PC6

P1num = 2;  % person number 2
P2num = 7;  % person number 7
P1 = faces(:,1+sum(nfaces(1:P1num-1)):sum(nfaces(1:P1num)));
P2 = faces(:,1+sum(nfaces(1:P2num-1)):sum(nfaces(1:P2num)));
P1 = P1 - avgFace*ones(1,size(P1,2));
P2 = P2 - avgFace*ones(1,size(P2,2));

figure 
subplot(1,2,1), imagesc(reshape(P1(:,1),n,m)); colormap gray, axis off
subplot(1,2,2), imagesc(reshape(P2(:,1),n,m)); colormap gray, axis off

% project onto PCA modes 5 and 6
PCAmodes = [5 6];
PCACoordsP1 = U(:,PCAmodes)'*P1;
PCACoordsP2 = U(:,PCAmodes)'*P2;

figure
plot(PCACoordsP1(1,:),PCACoordsP1(2,:),'kd','MarkerFaceColor','k')
axis([-4000 4000 -4000 4000]), hold on, grid on
plot(PCACoordsP2(1,:),PCACoordsP2(2,:),'r^','MarkerFaceColor','r')
set(gca,'XTick',[0],'YTick',[0]);