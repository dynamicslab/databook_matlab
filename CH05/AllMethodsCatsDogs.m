% here's part from class
% load data ...
% do wavelets ..
% take svd ...
data = [5+ 2*randn(32*32, 80),  .1*randn(32*32, 80)];
[u,s,v] = svd(data,0);

% *** so replace above with the real cat and dog data  ***


% set up
xdog=v(1:80,2:4); 
xcat=v(81:160,2:4);
xtrain=[xdog(1:50,:);xcat(1:50,:)]; 
xtest=[xdog(51:80,:);xcat(51:80,:)];
Ctrain=[ones(50,1); 2*ones(50,1)];
Ctest=[ones(30,1); 2*ones(30,1)];

% k-NN
knn = fitcknn(xtrain, Ctrain);
predKNN = predict(knn,xtest);

cMatKNN = confusionmat(Ctest, predKNN)
errorKNN = sum(abs(predKNN-Ctest))/60*100

% LDA
predLDA = classify(xtest, xtrain, Ctrain);

cMatLDA = confusionmat(Ctest, predLDA)
errorLDA = sum(abs(predLDA-Ctest))/60*100


% Naive Bayes
nb=fitNaiveBayes(xtrain,Ctrain);
predNB=nb.predict(xtest);

cMatNB=confusionmat(Ctest, predNB)
errorNB=sum(abs(predNB-Ctest))/60*100

% SVM 
svm = svmtrain(xtrain,Ctrain);
predSVM = svmclassify(svm,xtest);

cMatSVM=confusionmat(Ctest,predSVM)
errorSVM=sum(abs(predSVM-Ctest))/60*100

% AdaBoost
% pick AdaBoost, 100 classifiers, weak learners are Discriminants 
ab = fitensemble(xtrain,Ctrain,'AdaBoostM1',100,'Discriminant');
predAB = predict(ab,xtest);

cMatAB = confusionmat(Ctest,predAB)
errorAB = sum(abs(predAB-Ctest))/60*100

% EM / Gaussian mixture models
gm = fitgmdist(xtrain, 2); % choose number of clusters
predKM = cluster(gm,xtest); % can use clustering to classify new data

cMatKM = confusionmat(Ctest,predKM)
errorKM = sum(abs(predKM-Ctest))/60*100

% some cool ways to view these clustering results are here:
% http://www.mathworks.com/help/stats/gaussian-mixture-models.html#brajyl2

% k-means
km = kmeans(xtrain, 2); % choose number of clusters
% I don't think they have a built-in way to evaluate this on new data?






