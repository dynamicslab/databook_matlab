clear all, close all, clc
load('CC2.mat')

p = 14;
n = 32;

%% PLOT PSI
figure
Psi = dct(eye(n));
pcolor(padflip(Psi))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 n*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_Psi1');
%% PLOT C
figure
C = eye(n);
perm = randperm(n,p);
C = C(perm,:); % compressed measurement
pcolor(padflip(C))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_C1');

%% PLOT THETA
figure
Theta = C*Psi;
pcolor(padflip(Theta))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_Theta1');
%% PLOT s, y
s = zeros(n,1);
s(3) = 1.4;
s(14) = 0.7;
s(28) = 2.2;
y = C*Psi*s;
figure
pcolor(padflip(s))
axis off, axis equal
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*12 n*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_s1');

sL2 = pinv(Theta)*y;
figure
pcolor(padflip(sL2))
axis off, axis equal
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*12 n*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_sL21');

sbackslash = Theta\y;
figure
pcolor(padflip(abs(sbackslash)))
axis off, axis equal
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*12 n*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_sbackslash1');

figure
pcolor(padflip(y))
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
axis off, axis equal
set(gcf,'Position',[100 100 p*12 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_y1');


cvx_begin;
    variable s2(n); 
    minimize( norm(s2,1) ); 
    subject to 
        Theta*s2 == y;
cvx_end;



%% PLOT C AND THETA (2) - GAUSSIAN RANDOM
C = randn(p,n);
figure
pcolor(padflip(C))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_C2');

figure
Theta = C*Psi;
pcolor(padflip(Theta))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_Theta2');

%% PLOT C AND THETA (3) - BERNOULLI RANDOM
C = randn(p,n);
C = C>0;
figure
pcolor(padflip(C))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_C3');

figure
Theta = C*Psi;
pcolor(padflip(Theta))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_Theta3');


%% PLOT C AND THETA (4) - SPARSE BERNOULLI
C = randn(p,n);
C = C>1;
figure
pcolor(padflip(C))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_C4');

figure
Theta = C*Psi;
pcolor(padflip(Theta))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_Theta4');

%% BAD C AND THETA (5) -- DCT MEAS
C = idct(eye(n));
% perm = randperm(n,p);
perm = n-p:n;
C = C(perm,:); % compressed measurement
Theta = C*Psi;

figure
pcolor(padflip(C))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_C5');

figure
Theta = C*Psi;
pcolor(padflip(Theta))
axis off
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
set(gcf,'Position',[100 100 n*8 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_Theta5');

y = Theta*s;

figure
pcolor(padflip(y))
colormap(gca,(CC))
set(gca,'Position',[0 0 1 1])
axis off, axis equal
set(gcf,'Position',[100 100 p*12 p*8])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/f_chCS_matrices_y1');

