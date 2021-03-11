$ontext
Verificar que si esté bien formulado el problema.
La solución del subproblema LD no da resultados lógicos.
El optimizador siempre igual uno de los dos z a 0.
Esto tiene sentido por como está formulado.
Pero, ¿se supone que asi funciona la descomposición Lagrangiana?

$offtext


Sets
    iter    "Iteraciones"   /1*100/
    cutset(iter);
    
cutset(iter) = no;

Scalars
    n_iter      "Numero de iteraciones" /0/
    n_max       "Máximo de iteraciones" /10000/
    lambda1      "Multiplicador" /0/
    lambda2      "Multiplicador" /0/
    lambda1_old  "Multiplicador iteracion anterior" /2/
    lambda2_old  "Multiplicador iteracion anterior" /2/
    tol         "Tolerancia" /1e-10/
    step /1/
    subgradiente1
    subgradiente2
    subgradiente1_old
    subgradiente2_old
    norma2
    J_dual;
    
Parameters
    lambda1CP(iter)
    lambda2CP(iter)
    subgradiente1CP(iter)
    subgradiente2CP(iter)
    dual_value(iter)
    ;

Variables
    x1
    x2
    z1
    z2
    J1
    J2
    J3
    JCP
    alpha;
        
Positive Variables
    theta1
    theta2;

Equations
    sub1
    sub2
    sub3
    restr1
    CP(iter)
    ObjCP;

sub1.. J1 =E= 2*(x1-2)*(x1-2) + lambda1*x1;

sub2.. J2 =E= 4*(x2-4)*(x2-4) + lambda2*x2;

sub3.. J3 =E= -lambda1*z1 - lambda2*z2;
restr1.. z1 + z2 =E= 5;

ObjCP..  JCP =E= alpha;
CP(cutset)..    alpha =L= dual_value(cutset) + subgradiente1CP(cutset)*(theta1 - lambda1CP(cutset)) + subgradiente2CP(cutset)*(theta2 - lambda2CP(cutset));

*Límites de las variables de decisión
x1.lo = 1;
x1.up = 10;
x2.lo = 1;
x2.up = 10;

z1.lo = 0;
z1.up = 10;
z2.lo = 0;
z2.up = 10;

theta1.lo = 0;
theta1.up = 100;
theta2.lo = 0;
theta2.up = 100;

*Valores iniciales de las variables de decisión
x1.l = 6;
x2.l = 3;

z1.l = 6;
z2.l = 3;

Model subproblema1 /sub1/;
Model subproblema2 /sub2/;
Model LD /sub3, restr1/;

Model CuttingPlanes /ObjCP, CP/;

*Las siguientes lineas de código sirven para crear un fichero
*donde se guardan los valores de x1, x2, lambda en cada iteración
File reporte /reporte.txt/;
put reporte;
put "     x1          x2          lambda1     lambda2" /;
reporte.nd = 5;

$ontext Método del subgraiente
subgradiente1_old = 0;
subgradiente2_old = 0;

while (n_iter < n_max,
    
*Subproblemas
    solve subproblema1 using nlp minimizing J1;
    solve subproblema2 using nlp minimizing J2;
    solve LD using lp minimizing J3;
    
*Master
    n_iter = n_iter + 1;
    
    subgradiente1 = x1.l - z1.l;
    subgradiente2 = x2.l - z2.l;
    step = 10/(n_iter+1);

    norma2 = sqrt( sqr(subgradiente1) + sqr(subgradiente2) );
    
    lambda1 = max(0, lambda1 + step*subgradiente1/norma2);
    lambda2 = max(0, lambda2 + step*subgradiente2/norma2);
       
*Criterios de parada
    if (norma2 < tol,
        break;
        );
        
    lambda1_old = lambda1;
    lambda2_old = lambda2;
    
    subgradiente1_old = subgradiente1;
    subgradiente2_old = subgradiente2;
    put x1.l, x2.l, lambda1, lambda2 /;
    );
$offtext

subgradiente1_old = 0;
subgradiente2_old = 0;

Loop (iter,
    
*Subproblemas
    solve subproblema1 using nlp minimizing J1;
    solve subproblema2 using nlp minimizing J2;
    solve LD using lp minimizing J3;
    
    J_dual = J1.l + J2.l + J3.l;
    
    subgradiente1 = x1.l - z1.l;
    subgradiente2 = x2.l - z2.l;    


    norma2 = sqrt( sqr(subgradiente1) + sqr(subgradiente2) );
    
    cutset(iter) = yes;
    
    dual_value(iter) = J_dual;
    
    subgradiente1CP(iter) = subgradiente1;
    subgradiente2CP(iter) = subgradiente2;
    
    lambda1CP(iter) = lambda1;
    lambda2CP(iter) = lambda2;
    
    solve CuttingPlanes using LP maximizing JCP;
    
    lambda1 = theta1.l;
    lambda2 = theta2.l
       
*Criterios de parada
    if (norma2 < tol,
        break;
        );
        
    lambda1_old = lambda1;
    lambda2_old = lambda2;
    
    subgradiente1_old = subgradiente1;
    subgradiente2_old = subgradiente2;
    put x1.l, x2.l, lambda1, lambda2, J_dual, norma2, subgradiente1, subgradiente2 /;
    );

Display x1.l, x2.l, z1.l, z2.l;