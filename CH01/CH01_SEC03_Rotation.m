clear all, close all, clc
theta = [pi/15; -pi/9; -pi/20]; 
Sigma = diag([3; 1; 0.5]);              % scale x, then y, then z

Rx = [1 0 0;                            % rotate about x-axis
    0 cos(theta(1)) -sin(theta(1));
    0 sin(theta(1)) cos(theta(1))];

Ry = [cos(theta(2)) 0 sin(theta(2));    % rotate about y-axis
    0 1 0;
    -sin(theta(2)) 0 cos(theta(2))];

Rz = [cos(theta(3)) -sin(theta(3)) 0;   % rotate about z-axis
    sin(theta(3)) cos(theta(3)) 0;
    0 0 1];

X = Rz*Ry*Rx*Sigma;                     % rotate and scale

%% Plot sphere
subplot(1,2,1), hold on
[x,y,z] = sphere(25);
h1=surf(x,y,z);
set(h1,'FaceAlpha',.7)
colormap jet, lighting phong,  axis equal
axis([-2 2 -2 2 -2 2]), view([45 26]) 

%%
xR = 0*x;  yR = 0*y;  zR = 0*z;

for i=1:size(x,1)
    for j=1:size(x,2)
        vec = [x(i,j); y(i,j); z(i,j)];
        vecR = X*vec;
        xR(i,j) = vecR(1);
        yR(i,j) = vecR(2);
        zR(i,j) = vecR(3);        
    end
end

subplot(1,2,2), hold on
h2=surf(xR,yR,zR,z);  % using the z-position of sphere for color
set(h2,'FaceAlpha',.7)
colormap jet, lighting phong,  axis equal
axis([-2 2 -2 2 -2 2]), view([45 26]) 
set(gcf,'Position',[100 100 800 350])