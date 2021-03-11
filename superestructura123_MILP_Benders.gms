$TITLE Superestructura clases optimización, Benders aplicado a MILP
$ontext
fecha: 01/03/2021
autor: Daniel Montes

Descomposición de Benders aplicada a un problema MILP donde las
variables binarias son consideradas como complicating constraints.

Se fija su valor añadiendo una restricción y se resuelve el LP resultante.
Los multiplicadores asociados con tal restricción (fix_y.M) se usan para
actualizar las variables binarias con el problema Master (Una forma de
Cutting Planes).

El problema master es MIP y el subproblema LP.
 
La solución es exactamente igual a la del problema monolítico.
$offtext

Sets
    i    /1*3/
    iter /1*10/
    cutset(iter)    "Set dinámico para Cutting Planes"
    ;

cutset(iter) = no;

Parameters
    sub_obj(iter)   "Valor objetivo de los subproblemas para Cutting Planes"
    lambda(i, iter) "Multiplicadores asociados con las restricciones de consistencia"
    y_k(i, iter)    "Matriz que contiene el valor de y en cada iteración para Cutting Planes"
    y_fx(i)         "Variable auxiliar para comunicar el master con el subproblema";

Scalars
    cf1 /1000/
    cf2 /1500/
    cf3 /2000/
    cv1 /250/
    cv2 /400/
    cv3 /550/
    pA  /500/
    pB  /950/
    pC  /1800/
    n1  /0.9/
    n2  /0.82/
    n3  /0.95/
    Amax /16/
    Cmax /10/;

Positive Variables
    A
    B2
    B3
    B_mercado
    B_fabrica
    C
    C2
    C3
    y_sub(i);

Binary Variables
    y(i)    "Variable binaria del master";

Variables
    J
    z
    alpha;

Equations
    Obj
    ProducirA
    ProducirB
    ProducirC
    ProducirC2
    ProducirC3
    MaxA
    MaxC2
    MaxC3
    Proceso23
    fix_y(i)
    ObjMaster
    CP(iter)
    ;


Obj.. J =E= -(pC*C - y_sub('1')*cf1 - cv1*A - pB*B_mercado - pA*A
            - y_sub('2')*cf2 - cv2*B2 - y_sub('3')*cf3 - cv3*B3);
ProducirA.. B_fabrica =E= n1*A;
ProducirB.. B2 + B3 =E= B_mercado + B_fabrica;
ProducirC.. C =E= C2 + C3;
ProducirC2.. C2 =E= n2*B2;
ProducirC3.. C3 =E= n3*B3;
MaxA.. A =L= y_sub('1')*Amax;
MaxC2.. C2 =L= y_sub('2')*Cmax;
MaxC3.. C3 =L= y_sub('3')*Cmax;
fix_y(i).. y_sub(i) =E= y_fx(i);

ObjMaster..     z =E= alpha;
CP(cutset)..    alpha =G= sub_obj(cutset) + sum(i, lambda(i, cutset)*(y(i) - y_k(i, cutset) ));
Proceso23.. y('2') + y('3') =L= 1;

model subproblema /Obj, ProducirA, ProducirB, ProducirC, ProducirC2, ProducirC3,
                   MaxA, MaxC2, MaxC3, fix_y/;

model master /Objmaster, CP, Proceso23/;

* Inicialización
alpha.lo = -10000;

y.l('1') = 0;
y.l('2') = 0;
y.l('3') = 1;

* Escribir a texto
File reporte /reporte.txt/;
put reporte;
*Limitar los decimales a cinco
reporte.nd = 5;

y_fx(i) = y.l(i);
y_k(i, '1') = y.l(i)
Loop(iter,

* Resolver el subproblema
    y_fx(i) = y_k(i, iter);
    solve subproblema using LP minimizing J;
    J.up = J.l;

* Resolver el master
    cutset(iter) = yes;
*   Recuperar información de la solución de los subproblemas
    lambda(i, iter) = fix_y.M(i);
    sub_obj(iter) = J.l;
    solve master using MIP minimizing z;
*   Fijar el valor de las variables para los subproblemas    
    y_k(i, iter+1) = y.l(i);
*   Actualizar limite inferior
    J.lo = alpha.l;

* Escribir a texto
    put y.l('1'), y.l('2'), y.l('3'), J.lo, J.l, J.up /;

* Verificar convergencia
    if (abs(J.lo - J.up) < 1e-6, break);

);

Display A.l, B_mercado.l, C2.l, C3.l;
