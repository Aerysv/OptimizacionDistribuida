$ontext
Lagrangian Decomposition of problem
min⁡〖2(x1 - 2)^2 + 4(x2 - 4)^2 〗
x1 + x2 = 5     ligadura
x≥0
La solución analítica es x1 = 1.333, x2 = 3.667.
Costo optimo J = 1.333 

$offtext

Scalars
   
    lambda1    "Multiplicador de Lagrange" /0/
    lambda2    "Multiplicador de Lagrange" /0/
    
    n_iter      "Numero de iteraciones" /0/
    n_iter_max  "Numero maximo de iteraciones" /100/
    epsilon     "Tamaño del gap maximo permitido" /1e-3/
    c           "Constante para el paso de lambda"  /5/
;

Positive Variables

    x1   "variable x1"
    x2   "variable x2"
    
    s1   "variable relajada x1"
    s2   "variable relajada x2"
    
;

Variables

    J1    "Funcion de costo individual de x1"
    J2    "Funcion de costo individual de x2"
    L1    "Lagrangiana 1"
    L2    "Lagrangiana 2"
    D2    "Costo Subproblema adicional"

    J_total  "Funcion de costo total"
;

Equations

    CostoIndividual1    "Función de costo 1"
    Lagrangiana1       "Funcion de costo modificada del subproblema 1"
    CostoIndividual2    "Función de costo 2"
    Lagrangiana2       "Funcion de costo modificada del subproblema 2"
    Recurso            "limitacion de la suma"
    CostoD2             "Costo subproblema adicional"
    CostoTotal          "Funcion de costo del problema global"
    ;

    CostoIndividual1..   J1 =E= 2*(x1 -2)*(x1 -2);
    Lagrangiana1..       L1 =E= J1 + lambda1*x1;
    CostoIndividual2..   J2 =E= 4*(x2 -4)*(x2 -4);
    Lagrangiana2..       L2 =E= J2 + lambda2*x2;   
    Recurso..            s1 + s2 -5 =E= 0;
    CostoD2..            D2  =E= - lambda1*s1 - lambda2*s2;
    CostoTotal..         J_total =E= J1 + J2;


model subproblema1 /CostoIndividual1, Lagrangiana1/;

model subproblema2 /CostoIndividual2, Lagrangiana2/;
             
model subproblemaD2 /Recurso, CostoD2/;

File report /reportDecompos.txt/;
put report;
*Limitar los decimales a cinco
report.nd = 5;
*Delimitar por comas
report.pc = 5;

Scalars
    subgradiente1  
    subgradiente2
    J_dual
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

while (n_iter <= n_iter_max,

*Subproblemas


    solve subproblema1 minimizing L1 using NLP;
     
    solve subproblema2 minimizing L2 using NLP;

    solve subproblemaD2 minimizing D2 using NLP;
   
* Lower bound. Se evalua el dual en la solución actual
    J_dual = L1.l + L2.l + D2.l ;
*  Se actualiza el limite inferior
    if (J_dual > J_dual_max, J_dual_max = J_dual;);
 
* Se calculan los subgradientes respecto a los dos recursos compartidos
    subgradiente1 = x1.l - s1.l;
    subgradiente2 = x2.l - s2.l;    
* Se actualiza el limite superior
    J_iter = J1.l + J2.l;
    if (((abs(x1.l + x2.l -5) <= epsilon ) and (J_iter < J_up)), J_up = J_iter; solx1 = x1.l; solx2 = x2.l; );

*  Se calcula el gap
    gap = J_up - J_dual_max;
    
*  Escribo resultados
    n_iter = n_iter + 1;
   
    put  n_iter, x1.l, x2.l, s1.l, s2.l, lambda1, lambda2, J_dual_max, J_up, gap, J_iter, solx1, solx2,J_up /;

*  Condicion de terminacion    
    if(gap <= epsilon, n_iter = n_iter_max +2; );
  
* Calculo de los nuevos lambdas
    step = (1 + c) / (n_iter + c);
    lambda1 = max(0, lambda1 + step*subgradiente1);
    lambda2 = max(0, lambda2 + step*subgradiente2);
    
     );

putclose;
Display solx1, solx2, lambda1, lambda2, gap, J_up;

    