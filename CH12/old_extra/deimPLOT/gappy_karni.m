clear all; close all; clc;

% harmonic oscillator modes
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
n=length(x); 
f=(exp(-(x-0.5).^2)+3*exp(-2*(x+1.5).^2))';

%% method 1: start with max of each mode

ns=[];
for j=1:10  % walk through the modes
  [s1,n1]=max(yharm(:,j)); % pick max
  ns=[ns n1];
end
P=zeros(n,1);  P(ns)=1;    
    
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
    f1=yharm*atild;  % iterative reconstruction
    E(1)=norm(f1-f);  % iterative error
    con(1)=cond(M2)

    figure(2)
plot(x,f,'r',x,f1,'k')

%% method 2: start with max and mins of each mode

ns=[];
for j=1:10  % walk through the modes
  [s1,n1]=max(yharm(:,j)); % pick max  
  ns=[ns n1];
end
for j=2:10
  [s2,n2]=min(yharm(:,j)); % pick max  
  ns=[ns n2];
end
P=zeros(n,1);  P(ns)=1;    
    
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
    f1=yharm*atild;  % iterative reconstruction
    E(2)=norm(f1-f);  % iterative error
    con(2)=cond(M2)

figure(3)
plot(x,f,'r',x,f1,'k')
    
%% method 3: search for extrema, then select random N sensors

nmax=[]; nmin=[]; 
for j=1:10  % walk through the modes
    nmaxt=[]; nmint=[];
    for jj=2:n-1
       if yharm(jj,j)>yharm(jj-1,j) & yharm(jj,j)>yharm(jj+1,j)
           nmax=[nmax jj];
           nmaxt=[nmaxt jj];
       end
       if yharm(jj,j)<yharm(jj-1,j) & yharm(jj,j)<yharm(jj+1,j)
           nmin=[nmin jj];
           nmint=[nmint jj];
       end
    end
    nst=[nmaxt nmint]
    Pt=zeros(n,1); Pt(nst)=1;
    Psum(:,j)=Pt;
end
ns=[nmax nmin];
figure(1) 
subplot(3,1,1), pcolor(yharm.'), axis off, colormap(hot)
subplot(3,1,2), pcolor(-Psum.'), axis off, colormap(hot)

    P=zeros(n,1);  P(ns)=1;    
    
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
    f1=yharm*atild;   % iterative reconstruction
    E(3)=norm(f1-f);  % iterative error
    con(3)=cond(M2)

figure(4)
plot(x,f,'r',x,f1,'k')

%%  select random 20 - shuffle

ntot=length(ns);
for jtrials=1:100
ni=randsample(ntot,20);
nsr=ns(ni);

   P=zeros(n,1);  P(nsr)=1;    
    
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
    f1=yharm*atild;  % iterative reconstruction
    E_tri(jtrials)=norm(f1-f);  % iterative error
    con_tri(jtrials)=cond(M2);
end
subplot(2,1,1), bar(log(con_tri),'Facecolor',[0.7 0.7 0.7])
subplot(2,1,2), bar(log(E_tri+1),'Facecolor',[0.7 0.7 0.7])

subplot(2,1,1), set(gca,'Xlim',[0 101],'Ylim',[0 10],'Xtick',[1 50 100],'Ytick',[0 5 10],'Xticklabel',{'','',''},'Yticklabel',{'','',''})
subplot(2,1,2), set(gca,'Xlim',[0 101],'Ylim',[0 3],'Xtick',[1 50 100],'Ytick',[0 1 2 3],'Xticklabel',{'','',''},'Yticklabel',{'','','',''})


E(4:5)=0; con(4:5)=0;
Estri=sort(E_tri); contri=sort(con_tri);
E(6:10)=Estri(1:5);
con(6:10)=contri(1:5);
con(11:12)=0; E(11:12)=0;



%%  method to compare -- Willcox condition number

n2=20;    % number of sensors
nall=1:n; ns=[];  %

for jsense=1:n2
    for jloop=1:(n-jsense)
        P=zeros(n,1); P(ns)=1;
        P(nall(jloop))=1; 
        for j=1:10
            for jj=1:j    % matrix M
                Area=trapz(x,P.*(yharm(:,j).*yharm(:,jj)));
                M2(j,jj)=Area; M2(jj,j)=Area;
            end
        end
        con2(jloop)=cond(M2);  % compute condition number                    
    end  %  end search through all points
    [s1,n1]=min(con2);   % find minimum condition number location
    kond(jsense)=s1; clear con2
    ns=[ns nall(n1)];  % add sensor location
    nall=setdiff(nall,ns);  % new sensor indeces 
 
    P=zeros(n,1);  P(ns)=1;    
    Psum(:,jsense)=P;
    
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
    f1(:,jsense)=yharm*atild;  % iterative reconstruction
    EW(jsense)=norm(f1(:,jsense)-f);  % iterative error
    
end  % end sensor loop

E(13)=EW(end);
con(13)=kond(end);

figure(9), 
subplot(2,1,1), bar(log(E+1),'Facecolor',[0.7 0.7 0.7]), hold on
subplot(2,1,2), bar(log(con),'Facecolor',[0.7 0.7 0.7]), hold on


dum1=zeros(13,1); dum1(13)=(EW(end));
dum2=zeros(13,1); dum2(13)=kond(end);
subplot(2,1,1), bar(log(dum1+1),'r')
subplot(2,1,2), bar(log(dum2),'r')

subplot(2,1,1), set(gca,'Xlim',[0 14],'Ylim',[0 2],'Xtick',[],'Ytick',[0 1 2],'Xticklabel',{'','',''},'Yticklabel',{'','',''})
subplot(2,1,2), set(gca,'Xlim',[0 14],'Ylim',[0 22],'Xtick',[],'Ytick',[0 10 20],'Xticklabel',{'','',''},'Yticklabel',{'','',''})


%break

figure(1)
subplot(3,1,1), bar(log(kond),'Facecolor',[0.7 0.7 0.7])
subplot(3,1,2), bar(log(EW+1),'Facecolor',[0.7 0.7 0.7])
subplot(3,1,3), pcolor(-Psum'), colormap(hot), axis off



figure(2), 
titer=[1:20 25]; f1=[f1 f]; titer2=[9:20 25], f2=[f1(:,9:20) f];



subplot(2,2,1), waterfall(x,titer,f1.'), colormap([0 0 0]), view(-150,50)
subplot(2,2,2), waterfall(x,titer2,f2.'), colormap([0 0 0]), view(-150,50)
subplot(2,2,1), set(gca,'Zlim',[-2 12],'Xlim',[-4 4],'Xtick',[-4 0 4],'Xticklabel',{'','',''}, ...
    'Ylim',[0 25],'Ytick',[1 10 20],'Yticklabel',{'','',''},'Ztick',[-2 0 4 8 12],'Zticklabel',{'','','',''})
subplot(2,2,2), set(gca,'Zlim',[-.2 4.2],'Xlim',[-4 4],'Xtick',[-4 0 4],'Xticklabel',{'','',''}, ...
    'Ylim',[0 25],'Ytick',[1 10 20],'Yticklabel',{'','',''},'Ztick',[0 1 2 3 4],'Zticklabel',{'','','',''})


figure(1)
subplot(3,1,2), set(gca,'Xlim',[0 21],'Xtick',[1 5 10 15 20],'Xticklabel',{'','','','',''},'Ylim',[0 6],'Ytick',[0 2 4 6],'Yticklabel',{'','','',''})
subplot(3,1,1), set(gca,'Xlim',[0 21],'Xtick',[1 5 10 15 20],'Xticklabel',{'','','','',''},'Ylim',[0 42],'Ytick',[0 20 40],'Yticklabel',{'','',''})






