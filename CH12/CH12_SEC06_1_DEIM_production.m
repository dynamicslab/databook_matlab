clear all; close all; clc;

L=40; n=256; x2=linspace(-L/2,L/2,n+1); x=x2(1:n); % spatial discretization
k=(2*pi/L)*[0:n/2-1 -n/2:-1].';                    % wavenumbers for FFT
t=linspace(0,2*pi,61);                      % time domain collection points

N=2;
u0=N*sech(x).';
ut=fft(u0);
[t,utsol]=ode45('nls_rhs',t,ut,[],k);
for j=1:length(t)
  usol(j,:)=ifft(utsol(j,:));
end

figure(1)
subplot(2,2,1)
waterfall(x,t,abs(usol)), shading interp, colormap([0 0 0])
set(gca,'Ylim',[0 2*pi]), figure(1), subplot(2,2,2)

%%
X=usol.';  % data matrix X
[U,S,W]=svd(X,0);  % SVD reduction

r=3;  % select rank truncation
Psi=U(:,1:r); % select POD modes
a=Psi'*u0; % project initial conditions


%%
NL=i*(abs(X).^2).*X;
[XI,S_NL,W]=svd(NL,0);

% first DEIM point
[Xi_max,nmax]=max(abs(XI(:,1)));
XI_m=XI(:,1);
z=zeros(n,1);
P=z; P(nmax)=1;

% DEIM points 2 to r
for j=2:r
    c=(P'*XI_m)\(P'*XI(:,j));
    res=XI(:,j)-XI_m*c;
    [Xi_max,nmax]=max(abs(res));
    XI_m=[XI_m,XI(:,j)]; 
    P=[P,z]; P(nmax,j)=1;    
end
  
P_NL=Psi'*( XI_m*inv(P'*XI_m) ); % nonlinear projection
P_Psi=P'*Psi; % interpolation of Psi

for j=1:r  % linear derivative terms 
    Lxx(:,j)=ifft(-k.^2.*fft(Psi(:,j)));
end
L=(i/2)*(Psi')*Lxx;  % projected linear term

[tt,a]=ode45('rom_deim_rhs',t,a,[],P_NL,P_Psi,L);
Xtilde=Psi*a';  % DEIM approximation
waterfall(x,t,abs(Xtilde')), shading interp, colormap([0 0 0])
set(gca,'Ylim',[0 2*pi])

%% QR DEIM
[Q,R,pivot]=qr(NL.');
P_qr=pivot(:,1:3);
figure(2), bar(P_qr)


