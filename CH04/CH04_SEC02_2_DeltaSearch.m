function mindel=delsearch(del,x,y,dfx,dfy,X,Y,F) 
x0=x-del*dfx; 
y0=y-del*dfy; 
mindel=interp2(X,Y,F,x0,y0);
