$ontext
Verificar que si esté bien formulado el problema.
La solución del subproblema LD no da resultados lógicos.
El optimizador siempre igual uno de los dos z a 0.
Esto tiene sentido por como está formulado.
Pero, ¿se supone que asi funciona la descomposición Lagrangiana?

$offtext


Sets

    iter    "Iteraciones"   /1*100/
    cutset(iter)
;
cutset(iter) = no;

Scalars

    n_iter      "Numero de iteraciones" /0/
    n_max       "Máximo de iteraciones" /30/
    lambda1     "Multiplicador de Lagrange" /0/
    lambda2     "Multiplicador de Lagrange" /0/
    tol         "Tolerancia" /1e-3/
    subgradiente1
    subgradiente2
    J_dual
;
    
Parameters
    lambda1CP(iter)
    lambda2CP(iter)
    subgradiente1CP(iter)
    subgradiente2CP(iter)
    dual_value(iter)
;

Positive Variables
    x1  "Variable x1"
    x2  "Variable x2"
    s1  "Variable relajada x1"
    s2  "Variable relajada x1"

Variables
    J1
    J2
    J3
    JCP
    alpha
;
        
Positive Variables
    theta1
    theta2
;

Equations
    CostoIndividual1
    CostoIndividual2
    CostoD2
    restr1
    CP(iter)
    CostoCP
;

    CostoIndividual1.. J1 =E= 2*(x1-2)*(x1-2) + lambda1*x1;
    CostoIndividual2.. J2 =E= 4*(x2-4)*(x2-4) + lambda2*x2;
    CostoD2.. J3 =E= -lambda1*s1 - lambda2*s2;
    restr1.. s1 + s2 =E= 5;
    CostoCP..  JCP =E= alpha;
    CP(cutset)..    alpha =L= dual_value(cutset) + subgradiente1CP(cutset)*(theta1 - lambda1CP(cutset)) + subgradiente2CP(cutset)*(theta2 - lambda2CP(cutset));
    
*Límites de las variables de decisión
x1.up = 10;
x2.up = 10;

s1.up = 10;
s2.up = 10;

theta1.lo = 0;
theta1.up = 100;
theta2.lo = 0;
theta2.up = 100;

Model subproblema1 /CostoIndividual1/;
Model subproblema2 /CostoIndividual2/;
Model D2 /CostoD2, restr1/;

Model CuttingPlanes /CostoCP, CP/;

*Fichero de texto
File reporte /reporte.txt/;
put reporte;
put "     x1          x2          lambda1     lambda2" /;
reporte.nd = 5;

Loop (iter,
    
*Subproblemas
    solve subproblema1 using nlp minimizing J1;
    solve subproblema2 using nlp minimizing J2;
    solve D2 using lp minimizing J3;
    
    J_dual = J1.l + J2.l + J3.l;
    
    subgradiente1 = x1.l - s1.l;
    subgradiente2 = x2.l - s2.l;    
    
    cutset(iter) = yes;
    
    dual_value(iter) = J_dual;
    
    subgradiente1CP(iter) = subgradiente1;
    subgradiente2CP(iter) = subgradiente2;
    
    lambda1CP(iter) = lambda1;
    lambda2CP(iter) = lambda2;
    
    solve CuttingPlanes using LP maximizing JCP;
    
    lambda1 = theta1.l;
    lambda2 = theta2.l
       
    put x1.l, x2.l, lambda1, lambda2, s1.l, s2.l /;
    );

Display x1.l, x2.l, s1.l, s2.l;