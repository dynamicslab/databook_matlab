s = tf([1 0],1);
Fi = (s-1)/(s^2+3*s+2);
Fo = 1/(s+1);

F = Fi*Fo;
step(F)
bode(F)
% clear all
% t = 0:.001:100;
% thetastar(:,1) = t;
% thetastar(:,2) = .01*exp(.01*t);
% fstar(:,1) = t;
% fstar(:,2) = [(0:.001:10)*0 (10.001:.001:100)*0+.01];