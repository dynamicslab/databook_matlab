clear all, close all, clc

sigma = 10;  % Lorenz's parameters (chaotic)
beta = 8/3;
rho = 28;
n = 3;  % State dimension

x0=[0; 1; 20];  % Initial condition

% Integrate
dt = 0.001;
tspan=[dt:dt:50];
options = odeset('RelTol',1e-12,'AbsTol',1e-12*ones(1,n));
[t,x]=ode45(@(t,x) lorenz(t,x,sigma,beta,rho),tspan,x0,options);


y0=[0; 0; 25];
xvec = -20:5:20;
yvec = -25:5:25;
zvec = -20:5:20;

[x0,y0,z0] = meshgrid(xvec+y0(1),yvec+y0(2),zvec+y0(3));
yIC(1,:,:,:) = x0;
yIC(2,:,:,:) = y0;
yIC(3,:,:,:) = z0;

dy = lorenz3D(0,yIC,sigma,beta,rho);
%%
h=quiver3(x0,y0,z0,squeeze(dy(1,:,:,:)),squeeze(dy(2,:,:,:)),squeeze(dy(3,:,:,:)),'Color',[.5 .5 .5],'LineWidth',1);
hold on
plot3(x(:,1),x(:,2),x(:,3),'r','LineWidth',1);

% plot3(x(:,1),x(:,2),x(:,3),'Color',[.5 .5 .5],'LineWidth',1);
count = 1;
for k=1:200:length(x)
    xC(count,:) = x(k,:);
    dyC(count,:) = squeeze(lorenz(0,x(k,:),sigma,beta,rho));
    count = count + 1;
end    
% quiver3(xC(:,1),xC(:,2),xC(:,3),dyC(:,1),dyC(:,2),dyC(:,3),'r','LineWidth',1.5,'AutoScaleFactor',2,'MarkerSize',10,'MaxHeadSize',1);
axis tight