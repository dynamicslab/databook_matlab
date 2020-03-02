clear all; close all; clc;

close all
figure(1)
load catData_w.mat
load dogData_w.mat
CD=[dog_wave cat_wave];
[u,s,v]=svd(CD-mean(CD(:)));


subplot(2,2,1)
plot(v(1:80,2),v(1:80,4),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot(v(81:end,2),v(81:end,4),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
set(gca,'Fontsize',[15]), hold on


dogcat=v(:,2:2:4);          
GMModel=fitgmdist(dogcat,2)
AIC= GMModel.AIC

subplot(2,2,1)
h=ezcontour(@(x1,x2)pdf(GMModel,[x1 x2]));
xlabel(''),ylabel(''),title('')
set(h,'Linecolor','k','Linewidth',[2])
axis([-.25 .25 -.25 .25])

subplot(2,2,2)
h=ezmesh(@(x1,x2)pdf(GMModel,[x1 x2]));
xlabel(''),ylabel(''),title(''), view(-16,40)
set(gca,'Fontsize',[15]), colormap(gray)
axis([-.25 .25 -.25 .25 0 30])


%% AIC scores

figure(2)
AIC = zeros(1,4);
GMModels = cell(1,4);
options = statset('MaxIter',500);
for k = 1:4
    GMModels = fitgmdist(dogcat,k,'Options',options,'CovarianceType','diagonal');
    AIC(k)= GMModels.AIC
    subplot(2,2,k)
    h=ezmeshc(@(x1,x2)pdf(GMModels,[x1 x2]));
    xlabel(''),ylabel(''),title('')
%    set(h,'Linecolor','k','Linewidth',[2])
%    axis([-.25 .25 -.25 .25 0 30])
end


