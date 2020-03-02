function C = QRsensors(Psi,p)
    [Q,R,pivot] = qr(Psi','vector');
    pivot
    C = zeros(p,size(Psi,1));
    for j=1:p
        C(j,pivot(j))=1;
    end
end