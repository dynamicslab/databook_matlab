function dy = lorenz3D(t,y,sigma,beta,rho)
% y is a three dimensional state-vector
dy = [
sigma*(y(2,:,:,:)-y(1,:,:,:));
y(1,:,:,:).*(rho-y(3,:,:,:))-y(2,:,:,:);
y(1,:,:,:).*y(2,:,:,:)-beta*y(3,:,:,:);
];