$ontext
Lagrangian Decomposition of problem solved with CP
min⁡〖2(x1 - 2)^2 + 4(x2 - 4)^2 〗
x1 + x2 = 5     ligadura
x≥0
La solución analítica es x1 = 1.333, x2 = 3.667. 

$offtext

Sets
    iter        "Iteraciones"   /1*50/
    cut(iter)   "Set dinámico de Cutting Planes"
;
cut(iter) = no;
Scalars
   
    lambda1    "Multiplicador de Lagrange" /0/
    lambda2    "Multiplicador de Lagrange" /0/
    
    n_iter      "Numero de iteraciones" /0/
    epsilon     "Tamaño del gap maximo permitido" /1e-3/
;

Parameters
    lambda1CP(iter)         "Multiplicador de Lagrange iteración anterior CP"
    lambda2CP(iter)         "Multiplicador de Lagrange iteración anterior CP"
    subgradiente1(iter)     "Subgradiente iteración anterior CP"
    subgradiente2(iter)     "Subgradiente iteración anterior CP"
    J_dual(iter)            "Valor dual iteración anterior C"
;

Positive Variables

    x1      "variable x1"
    x2      "variable x2"
    
    s1      "variable relajada x1"
    s2      "variable relajada x2"
    
    theta1  "Actualización Multiplicador Lagrange CP"
    theta2  "Actualización Multiplicador Lagrange CP"
    
;

Variables

    J1    "Funcion de costo individual de x1"
    J2    "Funcion de costo individual de x2"
    L1    "Lagrangiana 1"
    L2    "Lagrangiana 2"
    D2    "Costo Subproblema adicional"
    
    alpha   "Variable Cutting Planes"
    J_CP    "Función de costo de Cutting Planes"
    
    J_total "Funcion de costo total"
;

Equations

    CostoIndividual1    "Función de costo 1"
    Lagrangiana1        "Funcion de costo modificada del subproblema 1"
    CostoIndividual2    "Función de costo 2"
    Lagrangiana2        "Funcion de costo modificada del subproblema 2"
    Recurso             "limitacion de la suma"
    CostoD2             "Costo subproblema adicional"
    CostoCP             "Función de costo del método Cutting Planes"
    CP(iter)            "Cortes de Cutting Planes"
    CostoTotal          "Funcion de costo del problema global"
    ;

    CostoIndividual1..   J1 =E= 2*(x1 -2)*(x1 -2);
    Lagrangiana1..       L1 =E= J1 + lambda1*x1;
    CostoIndividual2..   J2 =E= 4*(x2 -4)*(x2 -4);
    Lagrangiana2..       L2 =E= J2 + lambda2*x2;   
    Recurso..            s1 + s2 -5 =L= 0;
    CostoD2..            D2  =E= - lambda1*s1 - lambda2*s2;
    CostoTotal..         J_total =E= J1 + J2;
    CostoCP..            J_CP =E= alpha;
    CP(cut)..            alpha =L= J_dual(cut) + subgradiente1(cut)*(theta1 - lambda1CP(cut)) + subgradiente2(cut)*(theta2 - lambda2CP(cut));

* Límites de las variables
x1.up = 10;
x2.up = 10;

s1.up = 10;
s2.up = 10;

theta1.up = 100;
theta2.up = 100;

model subproblema1 /CostoIndividual1, Lagrangiana1/;

model subproblema2 /CostoIndividual2, Lagrangiana2/;
             
model subproblemaD2 /Recurso, CostoD2/;

Model CuttingPlanes /CostoCP, CP/;

File report /reportDecompos_CP.txt/;
put report;
*Limitar los decimales a cinco
report.nd = 5;
*Delimitar por comas
report.pc = 5;

Scalars
    J_iter
    step
    gap
    J_dual_max /-inf/
    J_up /inf/
    solx1
    solx2;
    

option NLP = ipopt;
subproblema1.optfile = 1;
subproblema2.optfile = 1;
subproblemaD2.optfile = 1;

Loop (iter,
    
*Subproblemas
    solve subproblema1 minimizing L1 using NLP;
    solve subproblema2 minimizing L2 using NLP;
    solve subproblemaD2 minimizing D2 using LP;
    
* Lower bound. Se evalua el dual en la solución actual
    J_dual(iter) = L1.l + L2.l + D2.l ;
    
*  Se actualiza el limite inferior
    if (J_dual(iter) > J_dual_max, J_dual_max = J_dual(iter););
    
* Se calculan los subgradientes respecto a los dos recursos compartidos
    subgradiente1(iter) = x1.l - s1.l;
    subgradiente2(iter) = x2.l - s2.l;       

* Se actualiza el limite superior
    J_iter = J1.l + J2.l;
    if (((abs(x1.l + x2.l -5) <= epsilon ) and(J_iter < J_up)), J_up = J_iter; solx1 = x1.l; solx2 = x2.l;);
*  Se calcula el gap
    gap = J_up - J_dual_max;
    
* Escribo resultados
    n_iter = n_iter + 1;
    
    put  n_iter, x1.l, x2.l, s1.l, s2.l, lambda1, lambda2, J_dual_max, J_up, gap, J_iter, solx1, solx2, J_up /;

*  Condicion de terminacion
    if(gap <= epsilon, break );
    
*  Calculo de los nuevos lambda
    cut(iter) = yes;
            
    lambda1CP(iter) = lambda1;
    lambda2CP(iter) = lambda2;
        
    solve CuttingPlanes maximizing J_CP using LP;
    
    lambda1 = theta1.l;
    lambda2 = theta2.l;
    

    );

putclose;
Display solx1, solx2, lambda1, lambda2, gap, J_up;

    