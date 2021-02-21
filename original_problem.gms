Variables

    x1
    x2
    lambda
    J;

Equations
    objetivo

    ;
    
objetivo .. J =E= 2*(x1-2)*(x1-2) + 4*(x2-4)*(x2-4) + lambda*(x1 + x2 - 5);
x1.lo = 0;
x1.up = 10;
x2.lo = 0;
x2.up = 10;

x1.l = 3;
x2.l = 2;

Model obj /all/;

Solve obj minimizing J using NLP;

Display x1.l, x2.l, lambda.l, J.l;