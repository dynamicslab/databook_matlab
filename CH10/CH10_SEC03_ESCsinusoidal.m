clear all, close all, clc

% J = @(u,t)(25-(5-(u-t))^2);

J = @(u,t)(25-(5-(u)-sin(t)).^2);
u = 0;
y0 = J(u,0);

% Extremum Seeking Control Parameters
freq = 100; % sample frequency
dt = 1/freq;
T = 100; % total period of simulation (in seconds)
A = .2;  % amplitude
omega = 10*2*pi; % 10 Hz
phase = 0;
K = 5;   % integration gain

% high pass filter
butterorder=1;
butterfreq=2;  % in Hz for 'high'
[b,a] = butter(butterorder,butterfreq*dt*2,'high')
ys = zeros(1,butterorder+1)+y0;
HPF=zeros(1,butterorder+1);

uhat=u;
for i=1:T/dt
    t = (i-1)*dt;
    time(i) = t;
    yvals(i)=J(u,t);
    
    for k=1:butterorder
        ys(k) = ys(k+1);
        HPF(k) = HPF(k+1);
    end
    ys(butterorder+1) = yvals(i);    
    HPFnew = 0;
    for k=1:butterorder+1
        HPFnew = HPFnew + b(k)*ys(butterorder+2-k);
    end
    for k=2:butterorder+1
        HPFnew = HPFnew - a(k)*HPF(butterorder+2-k);
    end
    HPF(butterorder+1) = HPFnew;
    
    xi = HPFnew*sin(omega*t + phase);
    uhat = uhat + xi*K*dt;
    u = uhat + A*sin(omega*t + phase);
    uhats(i) = uhat;
    uvals(i) = u;    
end

%%
figure
subplot(2,1,1)
plot(time,uvals,time,uhats,'LineWidth',1.2)
l1=legend('$u$','$\hat{u}$')
set(l1,'interpreter','latex','Location','SouthEast')
grid on
subplot(2,1,2)
plot(time,yvals,'LineWidth',1.2)
ylim([-1 26])
grid on

set(gcf,'Position',[100 100 500 350])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', '../../../figures/ESC_ResponseVarying');