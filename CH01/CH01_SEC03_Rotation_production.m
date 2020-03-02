clear all, close all, clc

xlim([-2 2])
ylim([-2 2])
zlim([-2 2])
% view([-72 18])
view([45 26]) 
% axis off

set(gca,'FontSize',13);
set(gcf,'Position',[100 100 300 300])
set(gcf,'PaperPositionMode','auto')
print('-depsc2', '-loose', 'CH01_EX09_1_axis.eps')

%% Define rotation matrix
t1 = pi/15;
t2 = -pi/9;
t3 = -pi/20;

Rx = [1 0 0;
    0 cos(t1) -sin(t1);
    0 sin(t1) cos(t1)];

Ry = [cos(t2) 0 sin(t2);
    0 1 0;
    -sin(t2) 0 cos(t2)];

Rz = [cos(t3) -sin(t3) 0;
    sin(t3) cos(t3) 0;
    0 0 1];

Sigma = diag([3; 1; 0.5]);

R = Rz*Ry*Rx*Sigma;

%% Plot sphere and great circles
[x,y,z] = sphere(250);
% subplot(1,2,1)
plot3([-2 2],[0 0],[0 0],'k','LineWidth',6);
hold on
plot3([0 0],[-2 2],[0 0],'k','LineWidth',6);
plot3([0 0],[0 0],[-2 2],'k','LineWidth',6);

h1=surf(x,y,z);
hold on
set(h1,'EdgeColor','none','FaceColor',[.5 .5 .5],'FaceAlpha',.75)
% set(h1,'FaceColor','none')
lighting phong
shading interp
axis equal

theta = (0:.001:1)*2*pi;
x1 = cos(theta);
y1 = sin(theta);
z1 = 0*theta;
x2 = 0*theta;
y2 = cos(theta);
z2 = sin(theta);
x3 = cos(theta);
y3 = 0*theta;
z3 = sin(theta);

plot3(x1,y1,z1,'k','LineWidth',6);
plot3(x2,y2,z2,'k','LineWidth',6);
plot3(x3,y3,z3,'k','LineWidth',6);

xlim([-2 2])
ylim([-2 2])
zlim([-2 2])
% view([-72 18])
view([45 26]) 
% axis off

set(gca,'FontSize',13);
set(gcf,'Position',[100 100 100 100])
set(gcf,'PaperPositionMode','auto')
set(gcf,'renderer','opengl')

axis off
%   save2pdf('CH01_EX09_1b.pdf',gcf,600)
% print('-depsc2', '-loose', 'CH01_EX09_1b.eps')
print('-dpng','-r1800' ,'-loose', 'CH01_EX09_1a.png')

%%
xR = 0*x;
yR = 0*y;
zR = 0*z;

for i=1:size(x,1)
    for j=1:size(x,2)
        vec = [x(i,j); y(i,j); z(i,j)];
        vecR = R*vec;
        xR(i,j) = vecR(1);
        yR(i,j) = vecR(2);
        zR(i,j) = vecR(3);        
    end
end

vec1 = [x1; y1; z1];
vec2 = [x2; y2; z2];
vec3 = [x3; y3; z3];

vec1R = R*vec1;
vec2R = R*vec2;
vec3R = R*vec3;

eX = [2; 0; 0];
eY = [0; 2; 0];
eZ = [0; 0; 2];
eXR = R*eX;
eYR = R*eY;
eZR = R*eZ;

x1R = vec1R(1,:);
y1R = vec1R(2,:);
z1R = vec1R(3,:);
x2R = vec2R(1,:);
y2R = vec2R(2,:);
z2R = vec2R(3,:);
x3R = vec3R(1,:);
y3R = vec3R(2,:);
z3R = vec3R(3,:);

figure
% plot3([0 -2],[0 0],[0 0],'Color',[.3 .3 .3],'LineWidth',6);
% hold on
% plot3([0 0],[0 -2],[0 0],'Color',[.3 .3 .3],'LineWidth',6);
% plot3([0 0],[0 0],[0 2],'Color',[.3 .3 .3],'LineWidth',6);
h1=surf(xR,yR,zR,z);
hold on
set(h1,'EdgeColor','none','FaceColor',[.5 .5 .5],'FaceAlpha',.75)
% set(h1,'FaceColor','none')
axis equal
shading interp
lighting phong

plot3(x1R,y1R,z1R,'k','LineWidth',6);
plot3(x2R,y2R,z2R,'k','LineWidth',6);
plot3(x3R,y3R,z3R,'k','LineWidth',6);

plot3([-eXR(1) eXR(1)],[-eXR(2) eXR(2)],[-eXR(3) eXR(3)],'k','LineWidth',6);
plot3([-eYR(1) eYR(1)],[-eYR(2) eYR(2)],[-eYR(3) eYR(3)],'k','LineWidth',6);
plot3([-eZR(1) eZR(1)],[-eZR(2) eZR(2)],[-eZR(3) eZR(3)],'k','LineWidth',6);

xlim([-2 2])
ylim([-2 2])
zlim([-2 2])
grid off

% view([-72 18])
view([45 26]) 
% axis off

set(gca,'FontSize',13);
set(gcf,'Position',[100 100 100 100])
set(gcf,'PaperPositionMode','auto')
set(gcf,'renderer','opengl')

axis off
%   save2pdf('CH01_EX09_1b.pdf',gcf,600)
% print('-depsc2', '-loose', 'CH01_EX09_1b.eps')
print('-dpng','-r1800' ,'-loose', 'CH01_EX09_1b.png')