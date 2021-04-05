Scalars
    n_iter      "Numero de iteraciones" /0/
    n_max       "Máximo de iteraciones" /1000/
    lambda      "Multiplicador" /1/
    lambda_old  "Multiplicador iteracion anterior" /2/
    tol         "Tolerancia" /1e-6/
    alpha       "Tamaño del paso subgradiente";

Variables
    x1
    x2
    J1
    J2;
        
Equations
    sub1
    sub2;

sub1.. J1 =e= 2*(x1-2)*(x1-2) + lambda*x1;

sub2.. J2 =e= 4*(x2-4)*(x2-4) + lambda*x2;

*Límites de las variables de decisión
x1.lo = 0;
x1.up = 10;
x2.lo = 0;
x2.up = 10;

*Valores iniciales de las variables de decisión
x1.l = 3;
x2.l = 2;

Model subproblema1 /sub1/;
Model subproblema2 /sub2/;

subproblema1.optfile = 1;
subproblema2.optfile = 1;

*Las siguientes lineas de código sirven para crear un fichero
*donde se guardan los valores de x1, x2, lambda en cada iteración
File reporte /reporte.txt/;
put reporte;
put "     x1          x2          lambda" /;
reporte.nd = 5;
*$ontext
while (n_iter < n_max,

    n_iter = n_iter + 1;
    
*Problema maestro
    alpha = 5/(n_iter**0.5);
    lambda = lambda + alpha*(x1.l + x2.l - 5);
    
*Subproblemas
    solve subproblema1 using nlp minimizing J1;
    solve subproblema2 using nlp minimizing J2;
    
*Criterios de parada
    if (abs(lambda - lambda_old) < tol,
        break;)
        ;
        
    lambda_old = lambda;
    put x1.l, x2.l, lambda /;
);
*$offtext
$ontext
*CFM rule

Scalars
    subgradiente
    s
    s_old
    beta_k
    gamma /1.5/;
    
s_old = x1.l + x2.l - 5;

while (n_iter < n_max,
    
*Subproblemas
    solve subproblema1 using nlp minimizing J1;
    solve subproblema2 using nlp minimizing J2;
    
*Master
    n_iter = n_iter + 1;
    alpha = 5/(n_iter**0.5);
    
    subgradiente = x1.l + x2.l - 5;
    beta_k = max(0, -gamma*s_old*subgradiente/(abs(sqr(subgradiente))**0.5));
    s = subgradiente + beta_k*s_old;
    lambda = lambda + alpha*s;
       
*Criterios de parada
    if (abs(lambda - lambda_old) < tol,
        break;)
        ;
        
    lambda_old = lambda;
    s_old = s;
    put x1.l, x2.l, lambda /;
    );
$offtext
scalar j_dual;
j_dual = J1.l + J2.l - lambda*5
Display x1.l, x2.l, j_dual;