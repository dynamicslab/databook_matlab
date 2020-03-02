clear all, close all, clc
%% System
mu = -.05;
lambda = -1;
A = [mu 0 0; 0 lambda -lambda; 0 0 2*mu];  % Koopman linear dynamics
[T,D] = eig(A);
slope_stab_man = T(3,3)/T(2,3);  % slope of stable subspace (green)

%% Integrate Koopman trajectories
y0A = [1.5; -1; 2.25];
y0B = [1; -1; 1];
y0C = [2; -1; 4];
tspan = 0:.01:1000;
[t,yA] = ode45(@(t,y)A*y,tspan,y0A);
[t,yB] = ode45(@(t,y)A*y,tspan,y0B);
[t,yC] = ode45(@(t,y)A*y,tspan,y0C);

%% Plot invariant surfaces
% Attracting manifold $y_2=y_1^2$ (red manifold)
[X,Z] = meshgrid(-2:.01:2,-1:.01:4);
Y = X.^2;
surf(X,Y,Z,'EdgeColor','None','FaceColor','r','FaceAlpha',.1)
hold on, grid on, view(-15,8), lighting gouraud

% Invariant set $y_3=y_1^2$ (blue manifold)
[X1,Y1] = meshgrid(-2:.01:2,-1:.01:4);
Z1 = X1.^2;
surf(X1,Y1,Z1,'EdgeColor','None','FaceColor','b','FaceAlpha',.1)

% Stable invariant subspace of Koopman linear system (green plane)
[X2,Y2]=meshgrid(-2:0.01:2,0:.01:4);
Z2 = slope_stab_man*Y2;  % for mu=-.2
surf(X2,Y2,Z2,'EdgeColor','None','FaceColor',[.3 .7 .3],'FaceAlpha',.7)

x = -2:.01:2;
% intersection of green and blue surfaces (below)
plot3(x,(1/slope_stab_man)*x.^2,x.^2,'-g','LineWidth',2) 
% intersection of red and blue surfaces (below)
plot3(x,x.^2,x.^2,'--r','LineWidth',2)  
plot3(x,x.^2,-1+0*x,'r--','LineWidth',2); 

%% Plot Koopman Trajectories (from lines 15-17)
plot3(yA(:,1),yA(:,2),-1+0*yA,'k-','LineWidth',1);
plot3(yB(:,1),yB(:,2),-1+0*yB,'k-','LineWidth',1);
plot3(yC(:,1),yC(:,2),-1+0*yC,'k-','LineWidth',1);
plot3(yA(:,1),yA(:,2),yA(:,3),'k','LineWidth',1.5)
plot3(yB(:,1),yB(:,2),yB(:,3),'k','LineWidth',1.5)
plot3(yC(:,1),yC(:,2),yC(:,3),'k','LineWidth',1.5)
plot3([0 0],[0 0],[0 -1],'ko','LineWidth',4)
set(gca,'ztick',[0 1 2 3 4 5])
axis([-4 4 -1 4 -1 4])
xlabel('y_1'), ylabel('y_2'), zlabel('y_3');