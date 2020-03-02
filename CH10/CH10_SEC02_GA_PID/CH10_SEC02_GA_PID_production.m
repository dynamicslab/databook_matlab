clear all, close all, clc

dt = 0.001;
popsize = 25;
MaxGenerations = 10;
s = tf('s');
G = 1/(s*(s*s+s+1));
rng(1,'twister') % for reproducibility

% population = rand(popsize,3);
load randpop.mat

options = optimoptions(@ga,'PopulationSize',popsize,'MaxGenerations',MaxGenerations,'InitialPopulation',population,'OutputFcn',@myfun);
[x,fval,exitflag,output,population,scores] = ga(@(K)pidtest(G,dt,K),3,-eye(3),zeros(3,1),[],[],[],[],[],options);

%%
load history.mat
for k=1:MaxGenerations
    sortedcost(:,k) = sort(cost(:,k));
end
imagesc(log(sortedcost(:,1:MaxGenerations)))
colorbar
set(gcf,'Position',[100 100 600 300])
set(gcf,'PaperPositionMode','auto')
print('-deps2', '-loose', '../../figures/GAPID1');
%%
figure
    hold on
    for k=1:MaxGenerations
        for j=1:popsize
            scatter3(history(j,1,k),history(j,2,k),history(j,3,k),15,[(MaxGenerations-k)/MaxGenerations 0.25 k/MaxGenerations],'filled');
        end
    end
      [B,I] = sort(cost(:,MaxGenerations));  
      scatter3(history(I(1),1,MaxGenerations),history(I(1),2,MaxGenerations),history(I(1),3,MaxGenerations),100,[0 0 0],'filled')
        view(69,24)
    box on
    xlabel('P')
    ylabel('I')
    zlabel('D')
set(gcf,'Position',[100 100 350 250])
set(gcf,'PaperPositionMode','auto')
print('-deps2', '-loose', '../../figures/GAPID2');
%% Plot Generation 1
gen = 1;
t = 0:dt:20;
s = tf('s');
figure
hold on
for k=1:popsize
    K = history(k,1,gen) + history(k,2,gen)/s + history(k,3,gen)*s/(1+.001*s);
    L = series(K,G);
    CL = feedback(L,1);
    [y,t] = step(CL,t);
    plot(t,y,'LineWidth',1.2);
end
box on, grid on
set(gcf,'Position',[100 100 550 250])
set(gcf,'PaperPositionMode','auto')
print('-deps2', '-loose', '../../figures/GAPID3');

%% Plot Generation 10
gen = 10;
t = 0:dt:20;
s = tf('s');
figure
hold on
for k=1:popsize
    K = history(k,1,gen) + history(k,2,gen)/s + history(k,3,gen)*s/(1+.001*s);
    L = series(K,G);
    CL = feedback(L,1);
    [y,t] = step(CL,t);
    plot(t,y,'LineWidth',1.2);
end
box on, grid on
set(gcf,'Position',[100 100 550 250])
set(gcf,'PaperPositionMode','auto')
print('-deps2', '-loose', '../../figures/GAPID4');
%% Plot BEST of each Generation
figure
for gen=1:MaxGenerations
    [B,I] = sort(cost(:,gen));
    K = history(I(1),1,gen) + history(I(1),2,gen)/s + history(I(1),3,gen)*s/(1+.001*s);
    L = series(K,G);
    CL = feedback(L,1);
    [y,t] = step(CL,t);
    subplot(3,1,1), hold on
    plot(t,y,'LineWidth',1+.1*gen,'Color',[(MaxGenerations-gen)/MaxGenerations 0 gen/MaxGenerations],'LineWidth',1.2);
    box on, grid on
    subplot(3,1,2), hold on
    CTRLtf = K/(1+K*G);
    u = lsim(K,1-y,t);
    plot(t,u,'LineWidth',1+.1*gen,'Color',[(MaxGenerations-gen)/MaxGenerations 0 gen/MaxGenerations],'LineWidth',1.2);
    ylim([-1 2])
    box on, grid on
    subplot(3,1,3), hold on
    Q = 1;
    R = .001;
    J = dt*cumsum(Q*(1-y(:)).^2 + R*u(:).^2);
    plot(t,J,'LineWidth',1+.1*gen,'Color',[(MaxGenerations-gen)/MaxGenerations 0 gen/MaxGenerations],'LineWidth',1.2);
end
box on, grid on
set(gcf,'Position',[100 100 550 350])
set(gcf,'PaperPositionMode','auto')
print('-deps2', '-loose', '../../figures/GAPID5');