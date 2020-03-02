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

%%  Willcox alg.

% sensor 1
for jloop=1:81

s=zeros(n,1); 
s(jloop)=1;


for j=1:10
   for jj=1:j
       Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end
figure(3), subplot(2,2,1), pcolor(10:-1:1,1:10,(M2'));, colormap(hot)


for j=1:10  % reconstruction using gappy
  ftild(j,1)=trapz(x,s.*(f.*yharm(:,j)));
end
atild=M2\ftild;   % compute error
f1=yharm*atild;
Er(1)=norm(f1-f);

con(jloop)=cond(M2);

end

[s1,n1]=min(con)


% sensor 2
jlook=[1:n1-1 n1+1:81];
for jloop=jlook

s=zeros(n,1); 
s(n1)=1;
s(jloop)=1;


for j=1:10
   for jj=1:j
       Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end
figure(3), subplot(2,2,2), pcolor(10:-1:1,1:10,(M2'));, colormap(hot)


for j=1:10  % reconstruction using gappy
  ftild(j,1)=trapz(x,s.*(f.*yharm(:,j)));
end
atild=M2\ftild;   % compute error
f2=yharm*atild;
Er(2)=norm(f2-f);

con2(jloop)=cond(M2);

end
[s2,n2]=min(con2(jlook))


% sensor 3
if n2>n1
   jlook=[1:n1-1 n1+1:n2-1 n2+1:81];
else
   jlook=[1:n2-1 n2+1:n1-1 n1+1:81];
end

for jloop=jlook

s=zeros(n,1); 
s(n1)=1; s(n2)=1;
s(jloop)=1;


for j=1:10
   for jj=1:j
       Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end
figure(3), subplot(2,2,3), pcolor(10:-1:1,1:10,(M2'));, colormap(hot)


for j=1:10  % reconstruction using gappy
  ftild(j,1)=trapz(x,s.*(f.*yharm(:,j)));
end
atild=M2\ftild;   % compute error
f3=yharm*atild;
Er(3)=norm(f3-f);

con3(jloop)=cond(M2);

end
[s3,n3]=min(con3(jlook))

% sensor 4
jlook=[1:n1-1 n1+1:n2-1 n2+1:n3-1 n3+1:81];
for jloop=jlook

s=zeros(n,1); 
s(n1)=1; s(n2)=1;
s(jloop)=1;


for j=1:10
   for jj=1:j
       Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end
figure(3), subplot(2,2,4),pcolor(10:-1:1,1:10,(M2'));, colormap(hot)

for j=1:10  % reconstruction using gappy
  ftild(j,1)=trapz(x,s.*(f.*yharm(:,j)));
end
atild=M2\ftild;   % compute error
f4=yharm*atild;
Er(4)=norm(f4-f);

con4(jloop)=cond(M2);

end
[s4,n4]=min(con3(jlook))




figure(1)
subplot(4,1,1), bar(log(con)), axis([1 81 0 100])
subplot(4,1,2), bar(log(con2)), axis([1 81 0 100])
subplot(4,1,3), bar(log(con3)), axis([1 81 0 100]) 
subplot(4,1,4), bar(log(con4)), axis([1 81 0 100]) 

figure(2)
subplot(4,1,1), plot(x,f1,'k',x,f,'r','Linewidth',[2])
subplot(4,1,2), plot(x,f2,'k',x,f,'r','Linewidth',[2])
subplot(4,1,3), plot(x,f3,'k',x,f,'r','Linewidth',[2])
subplot(4,1,4), plot(x,f4,'k',x,f,'r','Linewidth',[2])


%%

ns=[]; jlook=1:81; 

for jsense=1:2

for jloop=jlook
s=zeros(n,1); s(ns)=1;

s(jloop)=1;


for j=1:10
   for jj=1:j
       Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end
con(jloop)=cond(M2);

end

length(con)
[s1,n1]=min(con)
ns=[ns n1];

clear jlook
jlook=[1:n1-1 n1+1:81];

length(jlook)

% reconstruct
s=zeros(n,1); 
s(ns)=1;

for j=1:10
   for jj=1:j
       Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end

for j=1:10  % reconstruction using gappy
  ftild(j,1)=trapz(x,s.*(f.*yharm(:,j)));
end
atild=M2\ftild;   % compute error
f1(:,jsense)=yharm*atild;
Er(jsense)=norm(f1(:,jsense)-f);


end

figure(4), bar(log(Er))


%% Test Random trials with P% of measurements
% spectrum of mu
break
per=[20 40 60 81];
for thresh=1:4


n2=randsample(n,per(thresh));
s=zeros(n,1); s(n2)=1;


for j=1:10
   for jj=1:j
       Area=trapz(x,s.*(yharm(:,j).*yharm(:,jj)));
       M2(j,jj)=Area; M2(jj,j)=Area;
   end
end

[v,d]=eigs(M2);
subplot(2,2,thresh)
plot(real(diag(d)),imag(diag(d)),'ko','Linewidth',[2])
axis([0 2 -1 1])
end








