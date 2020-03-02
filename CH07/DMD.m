function [Phi, Lambda, b] = DMD(X,Xprime,r)

[U,Sigma,V] = svd(X,'econ');      % Step 1
Ur = U(:,1:r);
Sigmar = Sigma(1:r,1:r);
Vr = V(:,1:r);

Atilde = Ur'*Xprime*Vr/Sigmar;    % Step 2
[W,Lambda] = eig(Atilde);         % Step 3

Phi = Xprime*(Vr/Sigmar)*W;       % Step 4
alpha1 = Sigmar*Vr(1,:)';
b = (W*Lambda)\alpha1;