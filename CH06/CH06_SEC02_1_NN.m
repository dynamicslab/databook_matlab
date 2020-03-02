clear all; close all; clc

load catData_w.mat; load dogData_w.mat; 
CD=[dog_wave cat_wave];

x=[dog_wave(:,1:40) cat_wave(:,1:40)];
x2=[dog_wave(:,41:80) cat_wave(:,41:80)];
label=[ones(40,1)  zeros(40,1); 
       zeros(40,1) ones(40,1)].';

net = patternnet(2,'trainscg');
net.layers{1}.transferFcn = 'tansig';

net = train(net,x,label);
view(net)
y = net(x);
y2= net(x2);
perf = perform(net,label,y);
classes2 = vec2ind(y);
classes3 = vec2ind(y2);

subplot(4,1,1), bar(y(1,:),'FaceColor',[.6 .6 .6],'EdgeColor','k')
subplot(4,1,2), bar(y(2,:),'FaceColor',[.6 .6 .6],'EdgeColor','k')
subplot(4,1,3), bar(y2(1,:),'FaceColor',[.6 .6 .6],'EdgeColor','k')
subplot(4,1,4), bar(y2(2,:),'FaceColor',[.6 .6 .6],'EdgeColor','k')

%%
% [x,t] = iris_dataset;
% net = patternnet(10);
% net = train(net,x,t);
% view(net)
% y = net(x);
% perf = perform(net,t,y);
% classes = vec2ind(y);
% 

