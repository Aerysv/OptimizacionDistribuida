$ontext
Ejemplo de Descomposición de Benders aplicada a un
problema MILP con tres variables continuas y una
discreta
$offtext

Set v /i1*i10/;

Scalars
    f_xy
    x_k
    lambda
    ;

Variables
    x_notbinary
    y1
    y2
    y3
    w feasability
    J
    J_sub
    alpha
    ;
    
Integer Variable x;
    
Equations
    obj_master
    g_master
    obj_sub
    g1
    g2
    g3
    h1
    ;
    
obj_master.. -2*x + alpha =E= J;
g_master.. alpha =G= f_xy + lambda*(x - x_k);
$ontext
obj_sub.. -1.5*y1 -2*y2 -2*y3 + 40*w=E= J_sub;
g1.. -y1 - 3*y2 + 2*x_notbinary -w =L= 2;
g2.. y1 + 3*y2 - x_notbinary -w =L= 3;
g3.. y3 - 3*x_notbinary =L= 3.5;
h1.. x_notbinary =E= x_k;
$offtext

obj_sub.. -1.5*y1 -2*y2 -2*y3=E= J_sub;
g1.. -y1 - 3*y2 + 2*x_notbinary =L= 2;
g2.. y1 + 3*y2 - x_notbinary=L= 3;
g3.. y3 - 3*x_notbinary =L= 3.5;
h1.. x_notbinary =E= x_k;

x.up = 100;
y1.lo = 0;
y2.lo = 0;
y3.lo = 0;
x.lo = 0;

model master /obj_master, g_master/;
model subproblema /obj_sub, g1, g2, g3, h1/;

Scalars
    n_iter /0/
    n_max /10/
    ;
    
File reporte /reporte.txt/;
put reporte;
reporte.nd = 5;

*Inicialización del master
x_k = x.up;
alpha.l = -50;
alpha.lo = -50;
while(n_iter < n_max, 
 
    n_iter = n_iter + 1;

    solve subproblema minimizing J_sub using LP;
    
    f_xy = J_sub.l;
    
    lambda = h1.M;
    
    J.up = f_xy - 2*x_k;
    J.lo = -2*x_k + alpha.l;
        
    solve master minimiznig J using MIP;
    
    x_k = x.l;
    
    put y1.l, y2.l, y3.l, x.l, alpha.l, J.up, J.lo, J.l, f_xy /;
    
    if ( abs(J.up - J.lo)< 1e-6,
        break;);

    );
Display y1.l, y2.l, y3.l, x.l, alpha.l, J.up, J.lo;