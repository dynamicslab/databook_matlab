clear all; close all; clc

load catData_w.mat; load dogData_w.mat; CD=[dog_wave cat_wave];
train=[dog_wave(:,1:60) cat_wave(:,1:60)];
test=[dog_wave(:,61:80) cat_wave(:,61:80)];
label=[ones(60,1); -1*ones(60,1)].';

A=label*pinv(train); test_labels=sign(A*test);
subplot(4,1,1), bar(test_labels,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis off
subplot(4,1,2), bar(A,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis([0 1024 -0.002 0.002]), axis off
figure(2), subplot(2,2,1)
A2=flipud(reshape(A,32,32)); pcolor(A2), colormap(gray), axis off

figure(1), subplot(4,1,3)
A=lasso(train.',label.','Lambda',0.1).'; 
test_labels=sign(A*test);
bar(test_labels,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis off
subplot(4,1,4)
bar(A,'FaceColor',[.6 .6 .6],'EdgeColor','k'), axis([0 1024 -0.008 0.008]), axis off
figure(2), subplot(2,2,2)
A2=flipud(reshape(A,32,32)); pcolor(A2), colormap(gray), axis off


