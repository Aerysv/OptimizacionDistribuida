Positive Variables
    mu
    x
    y;

Variables
    z
    z1
    z2;

Equations
    obj
    cost1
    cost2;
    
obj.. z =E= 4*mu - 0.5*mu*mu;
cost1.. z1 =E= x*x - mu*x;
cost2.. z2 =E= y*y - mu*y;


model dual /obj/;
model sub1 /cost1/;
model sub2 /cost2/;
*Se resuelve el problema master
Solve dual maximizing z using nlp;
*Se debe fijar el valor de mu para que el subproblema no lo intente variar
mu.up = mu.l;
mu.lo = mu.l;
*Se resuelven los subproblemas
Solve sub1 minimizing z1 using nlp;
solve sub2 minimizing z2 using nlp;
Display x.l, y.l, mu.l;
