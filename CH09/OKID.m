function [H, M] = OKID(y,u,r)

% Steve Brunton, November 2010
% OKID code, based on 1991 NASA TM-104069 by Juang, Phan, Horta and Longman
% inputs: y (sampled output), u (sampled input), r (effective system order)
% outputs: H (Markov parameters), M (Observer gain)

% lowercase u,y indicate sampled data
% double uppercase UU, YY indicate bold-faced quantities in paper
% single uppercase U, Y indicate script quantities in paper

% Step 0, check shapes of y,u
yshape = size(y);
PP = yshape(1);  % q is the number of outputs 
MM = yshape(2);  % L is the number of output samples
ushape = size(u);
QQ = ushape(1);  % m is the number of inputs
lu = ushape(2); % Lu i the number of input samples 
assert(MM==lu);  % L and Lu need to be the same length


% Step 1, choose p (4 or 5 times effective system order)
LL = r*5;


% Step 2, form data matrices y and V as shown in Eq. (7), solve for observer Markov parameters, Ybar
V = zeros(QQ + (QQ+PP)*LL,MM);
for i=1:MM
    V(1:QQ,i) = u(1:QQ,i);
end
for i=2:LL+1
    for j=1:MM+1-i
        vtemp = [u(:,j);y(:,j)];
        V(QQ+(i-2)*(QQ+PP)+1:QQ+(i-1)*(QQ+PP),i+j-1) = vtemp;
%         V((i-1)*(m+q):i*(m+q)-1,i+j-1) = vtemp;
    end
end
Ybar = y*pinv(V,1.e-3);

% Step 3, isolate system Markov parameters H, and observer gain M
D = Ybar(:,1:QQ);  % feed-through term (or D matrix) is the first term

for i=1:LL
    Ybar1(1:PP,1:QQ,i) = Ybar(:,QQ+1+(QQ+PP)*(i-1):QQ+(QQ+PP)*(i-1)+QQ);
    Ybar2(1:PP,1:QQ,i) = Ybar(:,QQ+1+(QQ+PP)*(i-1)+QQ:QQ+(QQ+PP)*i);
end
Y(:,:,1) = Ybar1(:,:,1) + Ybar2(:,:,1)*D;
for k=2:LL
    Y(:,:,k) = Ybar1(:,:,k) + Ybar2(:,:,k)*D;
    for i=1:k-1
        Y(:,:,k) = Y(:,:,k) + Ybar2(:,:,i)*Y(:,:,k-i);
    end
end

H = D;
H(:,:,1) = D;
for k=2:LL+1
    H(:,:,k) = Y(:,:,k-1);
end

% H = Ybar;
M = 0; % not computed yet!