function rhs=rhs(tspan, a,dummy,VB, PV, VLV)

N=PV*a;
rhs=VLV*a+(i* VB*((abs(N).^2).*N));

end