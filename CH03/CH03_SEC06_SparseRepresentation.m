clear all, close all, clc
load ../../CH01_SVD/DATA/allFaces.mat
X = faces;
%% Build Training and Test sets
nTrain = 30;  nTest = 20;  nPeople = 20;
Train = zeros(size(X,1),nTrain*nPeople);
Test = zeros(size(X,1),nTest*nPeople);
for k=1:nPeople
    baseind = 0;
    if(k>1) baseind = sum(nfaces(1:k-1));
    end
    inds = baseind + (1:nfaces(k));
    Train(:,(k-1)*nTrain+1:k*nTrain)=X(:,inds(1:nTrain));
    Test(:,(k-1)*nTest+1:k*nTest)=X(:,inds(nTrain+1:nTrain+nTest));       
end




%% DOWNSAMPLE TRAINING IMAGES (BUILD THETA)
M = size(Train,2);

Theta = zeros(120,M);
for k=1:M
    temp = reshape(Train(:,k),n,m);
    tempSmall = imresize(temp,[12 10],'lanczos3');
    Theta(:,k) = reshape(tempSmall,120,1);
end

%% RENORMALIZE COLUMNS OF THETA
for k=1:M
    normTheta(k) = norm(Theta(:,k));
    Theta(:,k) = Theta(:,k)/normTheta(k);
end

%% OCCLUDE TEST IMAGE (Test(:,126)= test image 6 person 7)
x1 = Test(:,126);  % clean image
mustache = double(rgb2gray(imread('mustache.jpg'))/255);
x2 = Test(:,126).*reshape(mustache,n*m,1); % mustache
randvec = randperm(n*m);
first30 = randvec(1:floor(.3*length(randvec)));
vals30 = uint8(255*rand(size(first30)));
x3 = x1;
x3(first30) = vals30; % 30% occluded
x4 = x1 + 50*randn(size(x1));  % random noise

%% DOWNSAMPLE TEST IMAGES
X = [x1 x2 x3 x4];
Y = zeros(120,4);
for k=1:4    
    temp = reshape(X(:,k),n,m);
    tempSmall = imresize(temp,[12 10],'lanczos3');
    Y(:,k) = reshape(tempSmall,120,1);
end

%% L1 SEARCH, TESTCLEAN
y1 = Y(:,1);
eps = .01;
cvx_begin;
    variable s1(M);   % sparse vector of coefficients
    minimize( norm(s1,1) );
    subject to
        norm(Theta*s1 - y1,2) < eps;
cvx_end;

plot(s1)
imagesc(reshape(Train*(s1./normTheta'),n,m))
imagesc(reshape(x1-(Train*(s1./normTheta')),n,m))

binErr = zeros(nPeople,1);
for k=1:nPeople
    L = (k-1)*nTrain+1:k*nTrain;
    binErr(k)=norm(x1-(Train(:,L)*(s1(L)./normTheta(L)')))/norm(x1)
end
bar(binErr)

%% L1 SEARCH, MUSTACHE
y2 = Y(:,2);
eps = 500;
cvx_begin;
    variable s2(M);                 % alph is slope of fit to be optimized 
    minimize( norm(s2,1) );
    subject to
        norm(Theta*s2 - y2,2) < eps;
cvx_end;

plot(s2,'k')
imagesc(reshape(Train*(s2./normTheta'),n,m)), colormap gray
imagesc(reshape(x2-(Train*(s2./normTheta')),n,m)), colormap gray

binErr = zeros(nPeople,1);
for k=1:nPeople
    L = (k-1)*nTrain+1:k*nTrain;
    binErr(k) = norm(x2-(Train(:,L)*(s2(L)./normTheta(L)')))/norm(x2)
end
bar(binErr)

%% L1 SEARCH, OCCLUSION
y3 = Y(:,3);
eps = 1000;
cvx_begin;
    variable s3(M);                 % alph is slope of fit to be optimized 
    minimize( norm(s3,1) );
    subject to
        norm(Theta*s3 - y3,2) < eps;
cvx_end;

imagesc(reshape(Train*(s3./normTheta'),n,m)), colormap gray
imagesc(reshape(x3-(Train*(s3./normTheta')),n,m)), colormap gray
caxis([0 255])


binErr = zeros(nPeople,1);
for k=1:nPeople
    L = (k-1)*nTrain+1:k*nTrain;
    binErr(k) = norm(x3-(Train(:,L)*(s3(L)./normTheta(L)')))/norm(x3)
end
bar(binErr)

%% L1 SEARCH, NOISE
y4 = Y(:,4);
eps = 10;
cvx_begin;
    variable s4(M);                 % alph is slope of fit to be optimized 
    minimize( norm(s4,1) );
    subject to
        norm(Theta*s4 - y4,2) < eps;
cvx_end;

plot(a4,'k')
imagesc(reshape(Train*(s4./normTheta'),n,m)), colormap gray
imagesc(reshape(x4-(Train*(s4./normTheta')),n,m)), colormap gray

binErr = zeros(nPeople,1);
for k=1:nPeople
    L = (k-1)*nTrain+1:k*nTrain;
    binErr(k) = norm(x4-(Train(:,L)*(s4(L)./normTheta(L)')))/norm(x4)
end
bar(binErr)

%% LEAST SQUARES IS NO GOOD
s4L2 = pinv(Train)*x4;
plot(s4L2,'k')
imagesc(reshape(Train*s4L2,n,m)), colormap gray
imagesc(reshape(x4-(Train*s4L2),n,m)), colormap gray
binErr = zeros(nPeople,1);
for k=1:nPeople
    L = (k-1)*nTrain+1:k*nTrain;
    binErr(k) = norm(x4-(Train(:,L)*(s4L2(L))))/norm(x4)
end
bar(binErr)