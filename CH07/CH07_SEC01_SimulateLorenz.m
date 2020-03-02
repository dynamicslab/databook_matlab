clear all, close all, clc

Beta = [10; 28; 8/3]; % Lorenz's parameters (chaotic)

x0=[0; 1; 20];  % Initial condition
dt = 0.001;
tspan=dt:dt:50;
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,3));

[t,x]=ode45(@(t,x) lorenz(t,x,Beta),tspan,x0,options);
plot3(x(:,1),x(:,2),x(:,3));

%%
hline = findobj(gcf, 'type', 'line')

set(hline(1),'Color','k','LineWidth',2)
xlabel('x')
ylabel('y')
zlabel('z')
view(50,10)
xlabel('x')
ylabel('y')
zlabel('z')
% axis off
x0 = -20
y0 = -25
z0 = 5;
hold on
scatter3(x0,y0,z0,5,'k.');

plot3([x0 x0+10],[y0 y0],[z0 z0],'k-','LineWidth',2)
plot3([x0 x0],[y0 y0+10],[z0 z0],'k-','LineWidth',2)
plot3([x0 x0],[y0 y0],[z0 z0+10],'k-','LineWidth',2)
axis equal
axis off

set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../figures/OverviewLorenz.eps');