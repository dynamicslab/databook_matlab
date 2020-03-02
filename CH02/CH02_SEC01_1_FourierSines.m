clear all, close all, clc

% Define domain
dx = 0.001;
L = pi;
x = (-1+dx:dx:1)*L;
n = length(x);   nquart = floor(n/4);

% Define hat function
f = 0*x;
f(nquart:2*nquart) = 4*(1:nquart+1)/n;
f(2*nquart+1:3*nquart) = 1-4*(0:nquart-1)/n;
plot(x,f,'-k','LineWidth',1.5), hold on

% Compute Fourier series
CC = jet(20);
A0 = sum(f.*ones(size(x)))*dx;
fFS = A0/2;
for k=1:20
    A(k) = sum(f.*cos(pi*k*x/L))*dx; % Inner product
    B(k) = sum(f.*sin(pi*k*x/L))*dx;
    fFS = fFS + A(k)*cos(k*pi*x/L) + B(k)*sin(k*pi*x/L);
    plot(x,fFS,'-','Color',CC(k,:),'LineWidth',1.2)
end


%% Plot amplitudes
figure
clear ERR
clear A
fFS = A0/2;
A(1) = A0/2;
ERR(1) = norm(f-fFS);
kmax = 100;
for k=1:kmax
    A(k+1) = sum(f.*cos(pi*k*x/L))*dx;
    B(k+1) = sum(f.*sin(pi*k*x/L))*dx;
%     plot(x,B(k)*sin(2*k*pi*x/L),'k-','LineWidth',1.2);
    fFS = fFS + A(k+1)*cos(k*pi*x/L) + B(k+1)*sin(k*pi*x/L);
    ERR(k+1) = norm(f-fFS)/norm(f);
end
thresh = median(ERR)*sqrt(kmax)*4/sqrt(3);
r = max(find(ERR>thresh));
r = 7;
subplot(2,1,1)
semilogy(0:1:kmax,A,'k','LineWidth',1.5)
hold on
semilogy(r,A(r+1),'bo','LineWidth',1.5)
xlim([0 kmax])
ylim([10^(-7) 1])
subplot(2,1,2)
semilogy(0:1:kmax,ERR,'k','LineWidth',1.5)
hold on
semilogy(r,ERR(r+1),'bo','LineWidth',1.5)
