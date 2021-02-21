$ontext
Ejemplo de Descomposición de Benders aplicada a un
problema MILP con tres variables continuas y una
discreta
$offtext

Variables
    y1
    y2
    y3
    J
    ;
    
Integer Variable x;
    
Equations
    obj
    g1
    g2
    g3
    ;
    
obj.. -1.5*y1 -2*y2 -2*y3 -2*x =E= J;
g1.. -y1 - 3*y2 + 2*x =L= 2;
g2.. y1 + 3*y2 - x=L= 3;
g3.. y3 - 3*x =L= 3.5;


x.up = 100;
y1.lo = 0;
y2.lo = 0;
y3.lo = 0;
x.lo = 0;

model master /all/;

solve master minimizing J using MIP;

Display y1.l, y2.l, y3.l, x.l;