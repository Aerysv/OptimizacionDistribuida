$ontext
Este fichero busca resolver un problema de optimización usando
Descomposición de Benders:

minimizar 3x*y_2 +y_1*_y_2
x,y1,y2
4y_1 - x**2 <= 5
2y_2**2 - x*y_2/3 <=2
y_1 >= 0
x >= 0
x <=12

Siendo x la "complicating variable"

$offtext

* Se declaran las variables del master y el subproblema
Variables
    x
    y1
    y2
    alpha
    J
    J_master;
    
* Declaración de los parámetros para la descomposición
Scalars
    n_iter /0/
    x_k /2/
    f_x_y1_y2 /1/
    lambda /1/;
    
* Declaración de ecuaciones
Equations
    obj
    g1
    g2
    h1
    obj_master
    res_alpha
    ;
    
obj.. J =E= 3*x*y2 + y1*y2;
g1.. 4*y1 - sqr(x) =L= 5;
g2.. 2*sqr(y2) - x*y2/3 =L= 2;
h1.. (x - x_k) =E= 0;
obj_master.. J_master =E= alpha;
res_alpha.. alpha =G= f_x_y1_y2 + lambda*(x - x_k);

* Declaraciones de limites superiores e inferiores
x.lo = 0;
x.up = 12;
y1.lo = 0;

J.lo = -1e6;
J.up = 1e6;

* Declración de modelos
model subproblema /obj, g1, g2, h1/;
model master /obj_master, res_alpha/;


* Escritura a un fichero de datos
File reporte /reporte.txt/;
put reporte;
reporte.nd = 5;

$ontext
La estructura que sigue el algoritmo es la siguiente:
    1. Aumentar el contador de iteraciones
    2. Resolver el subproblema para un valor de x_k dado
    3. Actualizar el valor del límite superior de J, el multiplicador
       asociado a la complicating variable, y el valor del objetivo
    4. Resolver el problema maestro, usando en la restricción de alpha
       el valor del objetivo del subproblema, y el multiplicador
    5. Actualizar el limite inferior de J y x_l.
    5. Verificar la convergencia
$offtext

while ( n_iter <= 10,

    n_iter = n_iter + 1;
    
    solve subproblema minimizing J using NLP;
    
    J.up = J.l;
    
    lambda = h1.M;
    
    f_x_y1_y2 = J.l;
    
    solve master minimizing J_master using NLP;
    
    J.lo = alpha.l;
    
    x_k = x.l;
    
    put x.l, y1.l, y2.l, J.lo, J.up, x_k /;
    
    if ( abs( (J.up - J.lo)/J.lo ) < 1e-6,
        break;
        );
    );

Display x.l, y1.l, y2.l, lambda, J_master.l;