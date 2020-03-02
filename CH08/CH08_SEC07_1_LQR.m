clear all, close all, clc

m = 1;
M = 5;
L = 2;
g = -10;
d = 1;

b = 1; % pendulum up (b=1)

A = [0 1 0 0;
    0 -d/M b*m*g/M 0;
    0 0 0 1;
    0 -b*d/(M*L) -b*(m+M)*g/(M*L) 0];
B = [0; 1/M; 0; b*1/(M*L)];

eig(A)
det(ctrb(A,B))

%%  Design LQR controller
Q = [1 0 0 0;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1];
R = .0001;

K = lqr(A,B,Q,R);

%% Simulate closed-loop system
tspan = 0:.001:10;
x0 = [-1; 0; pi+.1; 0];  % initial condition 
wr = [1; 0; pi; 0];      % reference position
u=@(x)-K*(x - wr);       % control law
[t,x] = ode45(@(t,x)pendcart(x,m,M,L,g,d,u(x)),tspan,x0);

for k=1:100:length(t)
    drawpend(x(k,:),m,M,L);
end

%%
plot(t,x,'LineWidth',2); hold on
l1 = legend('x','v','\theta','\omega')
set(l1,'Location','SouthEast')
set(gcf,'Position',[100 100 500 200])
xlabel('Time')
ylabel('State')
grid on
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_02_LQR');

%% Compare with many examples of Pole Placement
K = lqr(A,B,Q,R);
u=@(x)-K*(x - wr);       % control law
[t,x] = ode45(@(t,x)pendcart(x,m,M,L,g,d,u(x)),tspan,x0);
xLQR = x;
for k=1:length(t)
    JLQR(k) = (x(k,:)-wr')*Q*(x(k,:)'-wr) + u(x(k,:)')^2*R;
end

CC = [0    0.4470    0.7410
    0.8500    0.3250    0.0980
    0.9290    0.6940    0.1250
    0.4940    0.1840    0.5560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

CCgray = [0.2    0.6470    0.9410
    0.9500    0.4250    0.1980
    1    0.7940    0.2250
    0.5940    0.2840    0.6560
    0.4660    0.6740    0.1880
    0.3010    0.7450    0.9330
    0.6350    0.0780    0.1840];

for count = 1:100
    p = [-.5-3*rand; -.5-3*rand; -.5-3*rand; -.5-3*rand];
	K = place(A,B,p);
    u=@(x)-K*(x - wr);       % control law
    [t,x] = ode45(@(t,x)pendcart(x,m,M,L,g,d,u(x)),tspan,x0);
    figure(1)
    for j=1:4
        plot(t(1:50:end),x(1:50:end,j),'Color',[.2 .2 .2] + .5*CC(j,:)), hold on;
    end
    for k=1:length(t)
        J(k) = (x(k,:)-wr')*Q*(x(k,:)'-wr) + u(x(k,:)')^2*R;
    end
    figure(2)
    Jz = cumtrapz(t,J);
    plot(t(1:50:end),Jz(1:50:end),'Color',[.5 .5 .5]), hold on;
end
figure(1)
    for j=1:4
        plot(t(1:10:end),xLQR(1:10:end,j),'Color',CC(j,:),'LineWidth',2)
    end
figure(2)
plot(t,cumtrapz(t,JLQR),'k','LineWidth',2)

figure(1)
set(gcf,'Position',[100 100 500 300])
xlabel('Time')
ylabel('State')
grid on
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_02b_LQRb');

figure(2)
set(gcf,'Position',[100 100 500 300])
xlabel('Time')
ylabel('Cost')
grid on
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'figures/FIG_02c_LQRb');