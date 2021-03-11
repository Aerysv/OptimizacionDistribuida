Variables

    x1
    x2
    J;

Equations
    objetivo
    restr
    ;
    
objetivo .. J =E= 2*(x1-2)*(x1-2) + 4*(x2-4)*(x2-4);
restr.. x1 + x2 =E= 5;
x1.lo = 0;
x1.up = 10;
x2.lo = 0;
x2.up = 10;

x1.l = 3;
x2.l = 2;

Model obj /all/;

Solve obj minimizing J using NLP;

Display x1.l, x2.l, J.l;