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


%%  method 1 --  condition number

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
        con(jloop)=cond(M2);  % compute condition number                    
    end  %  end search through all points
    [s1,n1]=min(con); % location to minimize condition #
    kond(jsense)=s1; clear con
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
    E(jsense)=norm(f1(:,jsense)-f);  % iterative error   
end  % end sensor loop

figure(1)
subplot(3,1,1), bar(log(kond),'Facecolor',[0.7 0.7 0.7])
subplot(3,1,2), bar(log(E+1),'Facecolor',[0.7 0.7 0.7])
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



%%  Method 2 -- max diagonal vs off-diagonal 

n2=60;    % number of sensors
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
        con(jloop)=2*sum(diag(M2))-sum(M2(:));  % compute proxy measure    
    end  %  end search through all points
    [s1,n1]=max(con);   % find maximum condition number location
    kond2(jsense)=s1; clear con
    ns=[ns nall(n1)];  % add sensor location
    nall=setdiff(nall,ns);  % new sensor indeces 

    P=zeros(n,1);  P(ns)=1;    
    Psum2(:,jsense)=P;
    
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
    f2(:,jsense)=yharm*atild;  % iterative reconstruction
    E2(jsense)=norm(f2(:,jsense)-f);  % iterative error

    
end  % end sensor loop



figure(4)
subplot(4,2,1), bar((kond2),'Facecolor',[0.7 0.7 0.7])
subplot(4,2,3), bar(log(E2+1),'Facecolor',[0.7 0.7 0.7])

axes('position',[.5 .55 .45 .38])
pcolor(-Psum2'), colormap(hot), axis off



%figure(5), 
%titer=[1:60 70]; f2=[f2 f]; titer2=[40:60 25], f3=[f2(:,40:60) f];
%subplot(2,2,1), waterfall(x,titer,f2.'), colormap([0 0 0]), view(-150,50)
%subplot(2,2,2), waterfall(x,titer2,f3.'), colormap([0 0 0]), view(-150,50)
%subplot(2,2,1), set(gca,'Zlim',[-2 12],'Xlim',[-4 4],'Xtick',[-4 0 4],'Xticklabel',{'','',''}, ...
%    'Ylim',[0 25],'Ytick',[1 10 20],'Yticklabel',{'','',''},'Ztick',[-2 0 4 8 12],'Zticklabel',{'','','',''})
%subplot(2,2,2), set(gca,'Zlim',[-.2 4.2],'Xlim',[-4 4],'Xtick',[-4 0 4],'Xticklabel',{'','',''}, ...
%    'Ylim',[0 25],'Ytick',[1 10 20],'Yticklabel',{'','',''},'Ztick',[0 1 2 3 4],'Zticklabel',{'','','',''})


figure(4)
subplot(4,2,3), set(gca,'Xlim',[0 61],'Xtick',[1 5 10 15 20],'Xticklabel',{'','','','',''},'Ylim',[0 12],'Ytick',[0 3 6 9 12],'Yticklabel',{'','','',''})
subplot(4,2,1), set(gca,'Xlim',[0 61],'Xtick',[1 5 10 15 20],'Xticklabel',{'','','','',''},'Ylim',[0 15],'Ytick',[0 5 10 15],'Yticklabel',{'','',''})




%%  method 1 --  first 4 condition number

figure(16)
n2=4;    % number of sensors
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
        con(jloop)=cond(M2);  % compute condition number                    
    end  %  end search through all points
    [s1,n1]=min(con);   % find minimum condition number location
    kond(jsense)=s1; 
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
    E(jsense)=norm(f1(:,jsense)-f);  % iterative error

    subplot(4,1,jsense), 
    if jsense==1
        contemp=con;
    elseif jsense==2
        contemp=[con(1:ns(1)-1) 0 con(ns(1):end)];  
        con2=contemp;
    elseif jsense==3
        contemp=[con(1:ns(1)-1) 0 con(ns(1):ns(2)-1) 0 con(ns(2):end)];
        con3=contemp;
    elseif jsense==4
        contemp=[con(1:ns(1)-1) 0 con(ns(1):ns(3)-1) 0 con(ns(3):ns(2)-1) 0 con(ns(2):end)];
    end
    bar(log(contemp),'Facecolor',[0.7 0.7 0.7]), axis([1 80 0 100])
    set(gca,'Xtick',[0 40 80],'Ytick',[0 50 100],'Xticklabel',{'','',''},'Yticklabel',{'','',''})

    subplot(4,1,jsense)
    if jsense==1
       temp=zeros(n,1), temp(n1)=s1; hold on, bar(log(temp),'r')
    elseif jsense==2
       temp=zeros(n,1), temp(n1+1)=s1; hold on, bar(log(temp),'r')
    elseif jsense==3
       temp=zeros(n,1), temp(n1+1)=s1; hold on, bar(log(temp),'r')
    elseif jsense==4
       temp=zeros(n,1), temp(n1+1)=s1; hold on, bar(log(temp),'r')
    end
        
       
    clear con
    
end  % end sensor loop



%temp=zeros(n,1), temp(n1)=s1; subplot(4,1,1),hold on, bar(log(temp),'r')
%temp=zeros(n,1), temp(n2)=s2; subplot(4,1,2),hold on, bar(log(temp),'r')
%temp=zeros(n,1), temp(n3)=s3; subplot(4,1,3),hold on, bar(log(temp),'r')
%temp=zeros(n,1), temp(n4)=s4; subplot(4,1,4),hold on, bar(log(temp),'r')











