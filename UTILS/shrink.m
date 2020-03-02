function out = shrink(X,tau)
    out = sign(X).*max(abs(X)-tau,0);
end