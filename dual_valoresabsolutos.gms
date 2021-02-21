Parameters
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

Positive Variables
    p1
    q1
    p2
    q2;
    
Equations
    sub1
    sub2
    x1Def
    x2Def;
    
sub1..  J1 =E= p1 + q1 + lambda*x1;
sub2..  J2 =E= p2 + q2 + lambda*x2;
x1Def.. 0 =E= x1 - 1 + p1 - q1;
x2Def.. 0 =E= x2 - 1 + p2 - q2;

*sub1..  J1 =E= (x1 - 1)*(x1 - 1) + lambda*x1;
*sub2..  J2 =E= (x2 - 1)*(x2 - 1) + lambda*x2;

x1.lo = 0;
x1.up = 10;
x2.lo = 0;
x2.up = 10;

Models
    subproblema1 /sub1, x1Def/
    subproblema2 /sub2, x2Def/;
*    subproblema1 /sub1/
*    subproblema2 /sub2/;
    
*Las siguientes lineas de código sirven para crear un fichero
*donde se guardan los valores de x1, x2, lambda en cada iteración
File reporte /reporte.txt/;
put reporte;
put "     x1          x2          lambda" /;
reporte.nd = 5;

while (n_iter < n_max,

    n_iter = n_iter + 1;
    
*Problema maestro
    alpha = 1/(n_iter**0.5);
    lambda = lambda + alpha*(x1.l + x2.l - 1);
    
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

Display x1.l, x2.l;