function rhs=a_rhs(t,a,dummy,phi,L)
rhs= L*a + i*phi'*( (abs(phi*a).^2).*(phi*a) );