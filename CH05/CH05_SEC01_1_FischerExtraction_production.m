clear all; close all; clc

load fisheriris;
x1=meas(1:50,:);    % setosa
x2=meas(51:100,:);  % versicolor
x3=meas(101:150,:); % virginica

plot3(x1(:,1),x1(:,2),x1(:,4),'ro','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0 1 0.2],'MarkerSize',8), hold on  
plot3(x2(:,1),x2(:,2),x2(:,4),'bo','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[0.9 0 1],'MarkerSize',8)
plot3(x3(:,1),x3(:,2),x3(:,4),'bo','Linewidth',[1],'MarkerEdgeColor','k','MarkerFaceColor',[1 0.64 0.098],'MarkerSize',8)            
grid on, set(gca,'Fontsize',[15])
legend('','','','Location','NorthWest'),legend boxoff








load dogData.mat
load catData.mat
CD=double([dog cat]);
[u,s,v]=svd(CD-mean(CD(:)),'econ');

figure(3)
for j=1:4
   subplot(2,2,j)
   U=flipud(reshape(u(:,j),64,64));
   U2=U(1:2:64,1:2:64);
   pcolor(U2), colormap(hot), axis off   
end

figure(4)
for j=1:4
    subplot(4,1,j), bar(v(:,j),'FaceColor',[.6 .6 .6],'EdgeColor','k') 
    set(gca,'Fontsize',[15]), axis([0 160 -0.2 0.2])
end

figure(5)
xbin=linspace(-0.25,0.25,20); 
for j=1:4
    subplot(4,2,2*j-1)
    pdf1=hist(v(1:80,j),xbin)
    pdf2=hist(v(81:160,j),xbin)
    plot(xbin,pdf1,xbin,pdf2,'Linewidth',[2])
    axis([-.2 0.2 0 20]), set(gca,'Fontsize',[15])
end

figure(2)
subplot(2,2,1)
plot3(v(1:80,1),v(1:80,2),v(1:80,3),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot3(v(81:end,1),v(81:end,2),v(81:end,3),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
view(-138,64), grid on, set(gca,'Fontsize',[15])
axis([-0.2 0.2 -0.2 0.2 -0.5 0.5])

% figure(2), subplot(2,2,3)
% plot(diag(s)/sum(diag(s)),'ko');
% axis([0 100 0 0.06])
% set(gca,'Fontsize',[15])


%dog_wave=dc_wavelet(dog);
%cat_wave=dc_wavelet(cat);

%%
load catData_w.mat
load dogData_w.mat
CD2=[dog_wave cat_wave];
[u2,s2,v2]=svd(CD2-mean(CD2(:)),'econ');

figure(6)
for j=1:4
 subplot(2,2,j)
 Xd=flipud(reshape(dog_wave(:,j),32,32));
 pcolor(Xd), colormap(hot), axis off
end


figure(7)
for j=1:4
   subplot(2,2,j)
   U3=flipud(reshape(u2(:,j),32,32));
   pcolor(U3), colormap(hot), axis off   
end

figure(8)
for j=1:4
    subplot(4,1,j), bar(v2(:,j),'FaceColor',[.6 .6 .6],'EdgeColor','k')
    set(gca,'Fontsize',[15]), axis([0 160 -0.2 0.2])
end

figure(5) 
for j=1:4
    subplot(4,2,2*j)
    pdf1=hist(v2(1:80,j),xbin);
    pdf2=hist(v2(81:160,j),xbin);
    plot(xbin,pdf1,xbin,pdf2,'Linewidth',[2])
    axis([-.2 0.2 0 20]), set(gca,'Fontsize',[15])
end

figure(2)
subplot(2,2,2)
plot3(v2(1:80,1),v2(1:80,2),v2(1:80,3),'ro','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0 1 0.2],...
                'MarkerSize',8), hold on   % [0.49 1 .63]
plot3(v2(81:end,1),v2(81:end,2),v2(81:end,3),'bo','Linewidth',[1],'MarkerEdgeColor','k',...
                'MarkerFaceColor',[0.9 0 1],...
                'MarkerSize',8)
view(-138,64), grid on, set(gca,'Fontsize',[15])
axis([-0.2 0.2 -0.2 0.2 -0.5 0.5])

% figure(2), subplot(2,2,4)
% plot(diag(s2)/sum(diag(s2)),'ko');
% axis([0 100 0 0.025])
% set(gca,'Fontsize',[15])

%%
figure(11)

master=zeros(32*5,32*4); count=1;
for jj=1:4
for j=1:5
  T2=flipud(reshape(dog(:,count),64,64)); 
  T=T2(1:2:64,1:2:64);
  master(1+32*(j-1):32+32*(j-1),1+32*(jj-1):32+32*(jj-1))=T;
  count=count+1;
end
end
pcolor(master), shading interp, colormap(gray), axis off

figure(12)

master=zeros(32*5,32*4); count=1;
for jj=1:4
for j=1:5
  T2=flipud(reshape(cat(:,count),64,64)); 
  T=T2(1:2:64,1:2:64);
  master(1+32*(j-1):32+32*(j-1),1+32*(jj-1):32+32*(jj-1))=T;
  count=count+1;
end
end
pcolor(master), shading interp, colormap(gray), axis off

