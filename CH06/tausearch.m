function mintau=tausearch(tau,x,y,dfx,dfy,X,Y,F) 
x0=x-tau*dfx; 
y0=y-tau*dfy; 
mintau=interp2(X,Y,F,x0,y0);
