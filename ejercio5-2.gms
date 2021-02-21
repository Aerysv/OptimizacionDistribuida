

Variables
    x
    y
    J
    lambda
    ;
    
Equations
    obj
    ;
    
obj.. J =E= sqr(x) + sqr(y) + lambda*(x + y - 10);

x.lo = 0;
y.lo = 0;


lambda.l = 10;
model problema /all/;

solve problema minimizing J using NLP;

Display x.l, y.l, J.l;