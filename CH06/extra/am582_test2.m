clear all; close all; clc

t=0:0.01:100;
x0=[5 5 5];

[t,Y]=ode45('lrz_rhs',t,x0);

x=Y(:,1); y=Y(:,2); z=Y(:,3);
plot3(x,y,z,'Linewidth',[2]), grid on

figure(2)
plot(t,x,t,y,t,z,'Linewidth',[2])

%%
figure(2)
plot(t,x,'Linewidth',[2])

%%
H=[x(1:5000).'
   x(2:5001).'
   x(3:5002).'
   x(4:5003).'
   x(5:5004).'
   x(6:5005).'
   x(7:5006).'
   x(8:5007).'];

[u,s,v]=svd(H,'econ');
figure(3), plot(diag(s)/(sum(diag(s))),'ro','Linewidth',[3])

%%
figure(4), plot(u(:,1:5),'Linewidth',[2])
figure(5), plot3(v(:,1),v(:,2),v(:,3),'Linewidth',[2])

figure(6), plot(v(:,4),'Linewidth',[2])






