clear all; close all;
figure(1)
% underdetermined
n=20; m=100
A=rand(n,m); b=rand(n,1);

cvx_begin;
variable x2(m)
minimize( norm(x2,2) );
subject to
A*x2 == b;
cvx_end;

cvx_begin;
variable x1(m)
minimize( norm(x1,1) );
subject to
A*x1 == b;
cvx_end;

subplot(3,1,1), bar(x2,'FaceColor',[.6 .6 .6],'EdgeColor','k')
subplot(3,1,2), bar(x1,'FaceColor',[.6 .6 .6],'EdgeColor','k')
subplot(3,2,5), hist(x2,40)
subplot(3,2,6), hist(x1,40)

subplot(3,1,1), axis([0 100 -.2 .2]), subplot(3,1,2), axis([0 100 -.4 .4])
subplot(3,2,5), axis([-.15 .15 0 82]), set(gca,'Ytick',[0 40 80],'Xtick',[-0.1 0 0.1])
h = findobj(gca,'Type','patch'); h.FaceColor = [0.6 0.6 0.6]; h.EdgeColor = 'k';
subplot(3,2,6), axis([-.15 .15 0 82]), set(gca,'Ytick',[0 40 80],'Xtick',[-0.1 0 0.1])
h = findobj(gca,'Type','patch'); h.FaceColor = [0.6 0.6 0.6]; h.EdgeColor = 'k';

%%
clear A
clear b
clear x
figure(2)

% overdetermined
n=500; m=100;
A=rand(n,m);
b=rand(n,1);
xdag=pinv(A)*b;

lam=[0 0.1 0.5];
for j=1:3
    
    cvx_begin;
    variable x(m)
    minimize( norm(A*x-b,2) + lam(j)*norm(x,1) );
    cvx_end;
    
    subplot(4,1,j),bar(x,'FaceColor',[.6 .6 .6],'EdgeColor','k')
    subplot(4,3,9+j), hist(x,20)
end


for j=1:3
    
    
    subplot(4,1,j), axis([0 100 -.15 .15])
    subplot(4,3,9+j), axis([-.15 .15 0 80]), set(gca,'Ytick',[0 40 80])
    h = findobj(gca,'Type','patch');
    h.FaceColor = [0.6 0.6 0.6];
    h.EdgeColor = 'k';
end


%%
% matrix overdetermined system

clear A
clear b
clear x
figure(3)

% overdetermined
n=300; m=60; p=20;
A=rand(n,m); b=rand(n,p);

lam=[0 0.1];
for j=1:2
    cvx_begin;
    variable x(m,p)
    minimize(norm(A*x-b,2) + lam(j)*norm(x,1));
    cvx_end;
    subplot(2,1,j), pcolor(x.'), colormap(hot), colorbar
end

%%
subplot(2,1,1), set(gca,'Fontsize',[15],'Xtick',[1 20 40 60],'Ytick',[1 10 20])
subplot(2,1,2), set(gca,'Fontsize',[15],'Xtick',[1 20 40 60],'Ytick',[1 10 20])







