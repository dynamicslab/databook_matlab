function rhs=lrz_rhs(t,x)
sigma=10; beta=8/3; rho=28; 
rhs=[sigma*(x(2)-x(1))
     x(1)*(rho-x(3))
     x(1)*x(2)-beta*x(3)];
 