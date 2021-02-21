
Parameters
    y_barra /3/
    x_barra /3/
    u /1/
    b /1/;

Positive Variables
    x
    y;
    
Variables
    J1
    J2;

Equations
    sub1
    sub2
    ;
    
sub1.. J1 =E= sqr(x) + 1/(2*b)*(sqr(max(0, u + b*(-x - y_barra + 4))) - sqr(u));

sub2.. J2 =E= sqr(y) + 1/(2*b)*(sqr(max(0, u + b*(-x_barra - y + 4))) - sqr(u));

Parameters
    n_max /100/
    n /0/
    tol /1e-6/
    step;
    
File reporte /reporte.txt/;
put reporte;
reporte.nd = 4;
    
while (n < n_max,
    n = n + 1;
    
    solve sub1 minimizing J1 using NLP;
    solve sub2 minimizing J2 using NLP;
    
    u = u + b*(-x -y -4);
    
    x_barra = x.l;
    y_barra = y.l;
    
    put x.l, y.l, u;

    if (abs(-x -y -4) < tol,
        break;);
        
    
    )