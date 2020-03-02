function E=fit3(x0,x,y)
E=sum(abs( x0(1)*x+x0(2)-y ).^2 );