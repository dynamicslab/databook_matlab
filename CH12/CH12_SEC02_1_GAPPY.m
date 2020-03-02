clear all; close all; clc;

%%
L=10; x3=-L:0.1:L; n=length(x3)-1; % define domain
x2=x3(1:n); k=(2*pi/(2*L))*[0:n/2-1 -n/2:-1]; % k-vector
ye=exp(-(x2.^2)); ye2=exp((x2.^2)/2); % define Gaussians
for j=0:9      % loop through 10 modes
  yd=real(ifft(((i*k).^j).*fft(ye))); % 2nd derivative 
  mode=((-1)^(j))*(((2^j)*factorial(j)*sqrt(pi))^(-0.5))*ye2.*yd;
  y(:,j+1)=(mode).';  % store modes as columns
end

x=x2(n/2+1-40:n/2+1+40);  % keep only -4<x<4
yharm=y(n/2+1-40:n/2+1+40,:); 


%%
n=length(x); 
f=(exp(-(x-0.5).^2)+3*exp(-2*(x+1.5).^2))';

for j=1:10  % full reconstruction
  a(j,1)=trapz(x,f.*yharm(:,j));
end
f2=yharm*a;
Efull(1)=log(norm(f2-f)+1);  % reconstruction error

for j=1:10  % matrix M reconstruction
   for jj=1:j
       Area=trapz(x,yharm(:,j).*yharm(:,jj));
       M(j,jj)=Area;
       M(jj,j)=Area;
   end
end
Cfull=cond(M)   % get condition number


%% Test Random trials with P% of measurements
for thresh=1:5;
  for jloop=1:1000  % 1000 random trials
    n2=randsample(n,8*thresh);  % random sampling 
    P=zeros(n,1); P(n2)=1;
    for j=1:10
        for jj=1:j   % compute M matrix
            Area=trapz(x,P.*(yharm(:,j).*yharm(:,jj)));
            M2(j,jj)=Area; M2(jj,j)=Area;
        end
    end
    for j=1:10  % reconstruction using gappy
        ftild(j,1)=trapz(x,P.*(f.*yharm(:,j)));
    end
    atild=M2\ftild;   % compute error
    f2=yharm*atild;   % compute reconstruction
    Err(jloop)=norm(f2-f); % L2 error
    con(jloop)=cond(M2);   % condition number
  end
  % mean and variance
  E(thresh)=mean(log(Err+1)); V(thresh)=(var(log(Err+1)));
  Ec(thresh)=mean(log(con)); Vc(thresh)=(var(log(con)));  
end
E=[E Efull]; V=[V 0];
Ec=[Ec log(Cfull)]; Vc=[Vc 0];
subplot(2,1,1), bar(E), hold on, errorbar(E,V,'r.')
subplot(2,1,2), bar(Ec), hold on, errorbar(Ec,Vc,'r.')

%%  For 20% measurements, sort great from bad

Pmaster=[];
for jloop=1:200  % 200 random trials
n2=randsample(n,20);
P=zeros(n,1); P(n2)=1;

 
Pmaster=[Pmaster P];

for j=1:10
   for jj=1:j
       Area=trapz(x,P.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end
for j=1:10  % reconstruction using gappy
  ftild(j,1)=trapz(x,P.*(f.*yharm(:,j)));
end
atild=M2\ftild;   % compute error
f2=yharm*atild;
Er(jloop)=norm(f2-f);
co(jloop)=cond(M2);

end

%%
figure(5)
subplot(3,1,1), bar(log(co))
subplot(3,1,2), hist(log(Er+1),50)
subplot(3,1,3), hist(log(co),50)

figure(7)
pcolor(-Pmaster.'), colormap(hot)

[Cloc,jloc]=sort(co);
figure(8)
%bar(log(Cloc));

jbest=jloc(1:11); jworst=jloc(end-10:end);
Sbest(:,1:11)=Pmaster(:,jbest);
Sworst(:,1:11)=Pmaster(:,jworst);
csor=[100*Cloc(1:10) zeros(1,10) Cloc(end-9:end)];

subplot(3,1,1), pcolor(-Sbest.'); colormap(hot)
subplot(3,1,2), pcolor(-Sworst.'); colormap(hot)
subplot(3,1,3), bar(csor)

%%
figure(7), axis off
figure(8), subplot(3,1,1), axis off
figure(8), subplot(3,1,2), axis off
figure(8), subplot(3,1,3), set(gca,'Xticklabel',{},'Yticklabel',{},'Xlim',[0 31])
figure(5), subplot(3,1,1), set(gca,'Xticklabel',{},'Yticklabel',{},'Xlim',[0 200])
figure(5), subplot(3,1,2), set(gca,'Xticklabel',{},'Yticklabel',{})
figure(5), subplot(3,1,3), set(gca,'Xticklabel',{},'Yticklabel',{})
figure(3), subplot(2,1,1), set(gca,'Xticklabel',{},'Yticklabel',{})
figure(3), subplot(2,1,2), set(gca,'Xticklabel',{},'Yticklabel',{})


%%

clear q
clear q2
figure(9)
m=30;
q=rand(m,m); n=m^2; 
p=randsample(n,200);
q2=zeros(m,m);
q2(p)=q(p);
p2=randsample(n,40);
q3=zeros(m,m);
q3(p2)=q(p2);
pcolor(-q), colormap(hot), caxis([-1 0]), axis off
figure(10)
pcolor(-q2), colormap(hot), caxis([-1 0]), axis off
figure(11)
pcolor(-q3), colormap(hot), caxis([-1 0]), axis off


