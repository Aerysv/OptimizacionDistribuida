Scalar lambda /1/;

Variables
    x
    y
    J1
    J2
    J
    ;
    
Equations
    obj1
    obj2
    ;
    
obj1.. J1 =E= sqr(x) + lambda*x;
obj2.. J2 =E= sqr(y) + lambda*y;

x.lo = 0;
y.lo = 0;

model sub1 /obj1/;
model sub2 /obj2/;

* Escritura a un fichero de datos
File reporte /reporte.txt/;
put reporte;
reporte.nd = 5;

* Declaración de variables para resolver por el subgradiente
Scalars
    n_iter /0/
    n_max /100/
    tol /1e-6/
    subgradiente /0/
    step_size /0/;
    
while (n_iter < n_max,
    n_iter = n_iter + 1;
    
    step_size = 1/(n_iter**0.5)
    
    solve sub1 minimizing J1 using NLP;
    solve sub2 minimizng J2 using NLP;
    
    put x.l, y.l, lambda /;
    
    subgradiente = x.l + y.l -10;
    
    if (abs(subgradiente) < tol,
           break);
        
    lambda = lambda + step_size*subgradiente;
       
    
    );


Display x.l, y.l;