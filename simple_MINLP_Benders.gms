$TITLE Ejercicio simple, descomposicion MINLP con enteros como complicating variables
$ontext
fecha: 01/03/2021
autor: Daniel Montes
comentarios: Descomposición de Benders aplicada a un problema MINLP donde las
             variables binarias son consideradas como complicating constraints.
$offtext

Sets
    iter    Iteraciones /1*100/
    cutset(iter);
    
cutset(iter) = no;

Parameters
    lambda(iter)
    x_k(iter)
    sub_obj(iter)
    x_fx
    ;

Variables
    y
    z
    x_sub
    x
    alpha
    J;
    
Binary Variable x;

Equations
    CP(iter)
    objMaster
    rest
    fix_x
    ObjSub;

objMaster..     z =E= alpha;
CP(cutset)..    alpha =G= sub_obj(cutset) + lambda(cutset)*(x - x_k(cutset) );

ObjSub..    J =E= -x_sub - y;
rest..      0.25 =E= 0.5*exp(2*y) - x_sub;
fix_x..     x_sub =E= x_fx;

y.lo = 0;
y.up = 0.5;

model master /objMaster, CP/;
model subproblema /ObjSub, rest, fix_x/;

* Inicialización
alpha.lo = -100;
* Como c_x < 0, x.init = x.up
x.l = 1;

Loop(iter,

* Resolver el subproblema
    x_k(iter) = x.l;
    x_fx = x_k(iter);
    solve subproblema using NLP minimizing J;
    
    lambda(iter) = fix_x.M;
    sub_obj(iter) = J.l;
    J.up = J.l;

* Resolver el master
    cutset(iter) = yes;
    solve master using MIP minimizing z;
    J.lo = alpha.l;
    
* Verificar convergencia
    if (abs(J.lo - J.up) < 1e-6, break);


);

Display x.l, y.l, J.l, J.lo, J.up;