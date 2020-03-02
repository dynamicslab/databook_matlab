clear all; close all; clc

%% fisher iris
load fisheriris;
tree=fitctree(meas,species,'MaxNumSplits',3,'CrossVal','on');
view(tree.Trained{1},'Mode','graph');
classError = kfoldLoss(tree)

x1=meas(1:50,:);    % setosa
x2=meas(51:100,:);  % versicolor
x3=meas(101:150,:); % virginica


plot3(x1(:,1),x1(:,2),x1(:,4),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on  
plot3(x2(:,1),x2(:,2),x2(:,4),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
plot3(x3(:,1),x3(:,2),x3(:,4),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 0.64 0.098],...
                'MarkerSize',8)            
grid on, set(gca,'Fontsize',[15])
legend('','','','Location','NorthWest')
legend boxoff

%% dogs vs cats
load catData_w.mat
load dogData_w.mat
CD=[dog_wave cat_wave];
[u,s,v]=svd(CD-mean(CD(:)));

features=1:20;
xtrain=[v(1:60,features); v(81:140,features)];          
label=[ones(60,1); -1*ones(60,1)];
test=[v(61:80,features); v(141:160,features)]; 
truth=[ones(20,1); -1*ones(20,1)];

Mdl = fitctree(xtrain,label,'MaxNumSplits',2,'CrossVal','on');
classError = kfoldLoss(Mdl)
view(Mdl.Trained{1},'Mode','graph');
classError = kfoldLoss(Mdl)


%% census data
figure(2)
load census1994
X = adultdata(:,{'age','workClass','education_num','marital_status','race','sex','capital_gain',...
    'capital_loss','hours_per_week','salary'});

Mdl = fitctree(X,'salary','PredictorSelection','curvature','Surrogate','on');

imp = predictorImportance(Mdl);

bar(imp,'FaceColor',[.6 .6 .6],'EdgeColor','k');
title('Predictor Importance Estimates');
ylabel('Estimates'); xlabel('Predictors'); h = gca;
h.XTickLabel = Mdl.PredictorNames;
h.XTickLabelRotation = 45;
h.TickLabelInterpreter = 'none';
set(gca,'Fontsize',[15])

%% splitting procedure

figure(4), subplot(2,2,1)
load fisheriris;
%tree = fitctree(meas,species,'MaxNumSplits',3,'CrossVal','on');
%view(tree.Trained{1},'Mode','graph');
%classError = kfoldLoss(tree)

x1=meas(1:50,:);    % setosa
x2=meas(51:100,:);  % versicolor
x3=meas(101:150,:); % virginica


plot(x1(:,3),x1(:,4),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on  
plot(x2(:,3),x2(:,4),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
plot(x3(:,3),x3(:,4),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 0.64 0.098],...
                'MarkerSize',8)            
grid on, set(gca,'Fontsize',[15])
plot([2.35 2.35],[0 3],'k:','Linewidth',[2])
plot([2.35 10],[1.75 1.75],'k:','Linewidth',[2])
plot([4.95 4.95],[0 1.75],'k:','Linewidth',[2])
axis([0 7 0 3])
%legend('','','','Location','NorthWest')
%legend boxoff


subplot(2,2,2)
plot(x1(:,1),x1(:,2),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on  
plot(x2(:,1),x2(:,2),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
plot(x3(:,1),x3(:,2),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 0.64 0.098],...
                'MarkerSize',8)            
grid on, set(gca,'Fontsize',[15])
axis([4 8 2 6])
legend('','','','Location','Best')
legend boxoff
