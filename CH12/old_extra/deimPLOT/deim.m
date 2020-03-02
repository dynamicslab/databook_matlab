clear all; close all; clc;

load data.mat
st=1;
fin=100;  % 95
U=usol(1:100,:)';
figure(1)
waterfall(abs(U'))
%surfl(abs(U')), shading interp
title('true soln')

L=40; n=512;
x2=linspace(-L/2,L/2,n+1); x=x2(1:n);
h=x(2)-x(1);
u0=2*sech(x)';


%%
%get modes for the system 
[VX,S,W]=svd((U),0);
figure(2)
plot(cumsum(diag(S)/sum(diag(S))), 'ko')
title('cumsum of svals of full data matrix')
xlim([0 20])
%3 modes enought
vk=3;
VX=VX(:,1:vk);
a=VX'*u0;
%  break

%%
%compute the nonlinear part
NL=zeros(n,fin-st+1);

for j=1:fin-st+1
   NL(:,j)=i*(abs(U(:,j))).^2.*U(:,j);
     
end

% p=512-128:512+128;
% ss=st:1:fin;
% NN=NL.';%NL(p,:)';
% 
% figure(2)
% waterfall(abs(NN))
% title('nonlinear part')
% 

[u,s,v]=svd(NL,0);
figure(3)
plot(cumsum(diag(s)/sum(diag(s))), 'ko')
%three modes are enough

m=vk;

%%
%Apply DEIM algorithm

%compute prjection matrix and indices
[ro,g(1)]=max(abs(u(:,1)));
U=u(:,1); 
z=zeros(n,1);
P=z; P(g(1))=1;


for l=2:m
    c=(P'*U)\(P'*u(:,l));
    r=u(:,l)-U*c;
    [ro,g(l)]=max(abs(r));
    U=[U,u(:,l)]; 
    P=[P,z]; P(g(l),l)=1;
    
end

figure(5), bar3(P)

B =U*inv(P'*U);    
VB=VX'*B;
PV=P'*VX;
k = (2*pi/L)*[0:n/2-1 -n/2:-1].';

for j=1:vk
    LV(:,j)=ifft(-k.^2.*fft(VX(:,j)));
end
    
VLV=i/2*VX'*LV;
dt=0.1;
tspan=0:0.1:9.5;
[tt, a]=ode45('rhs',tspan, a,[],VB, PV, VLV);

% figure(3)
% plot(tt, abs(a(:,1)))
% size(a)

recon=VX*a';


figure(4)
waterfall(abs(recon'))
%surfl(abs(recon')), shading interp

% norm(recon-X)

