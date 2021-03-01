$TITLE Superestructura clases optimización, monolítico
$ontext
fecha: 01/03/2021
autor: Daniel Montes
$offtext


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
    C3;
    
Binary Variables
    x1
    x2
    x3;

Variables
    J;

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
    ;


Obj.. J =E= -(pC*C - x1*cf1 - cv1*A - pB*B_mercado - pA*A 
            - x2*cf2 - cv2*B2 - x3*cf3 - cv3*B3);

ProducirA.. B_fabrica =E= n1*A;
ProducirB.. B2 + B3 =E= B_mercado + B_fabrica;
ProducirC.. C =E= C2 + C3;
ProducirC2.. C2 =E= n2*B2;
ProducirC3.. C3 =E= n3*B3;

MaxA.. A =L= x1*Amax;
*MaxB_fabrica.. B_fabrica =L= 1000*x1;
*MaxB_mercado.. B_mercado =L= 1000*(1-x1);
MaxC2.. C2 =L= x2*Cmax;
MaxC3.. C3 =L= x3*Cmax;

Proceso23.. x2 + x3 =L= 1;

model monolitico /all/;

solve monolitico using MIP minimizing J;
