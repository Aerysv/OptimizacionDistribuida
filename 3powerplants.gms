
Sets
    t /t1, t2, t3/
    i /gen1, gen2, gen3/
    ;

Parameters
    c(i) /gen1 0.100, gen2 0.125, gen3 0.150/
    d(t) /t1 150, t2 300, t3 500/
    dP_up(i) /gen1 200, gen2 100, gen3 100/
    dP_do(i) /gen1 300, gen2 150, gen3 100/
    ;

Variables
    P(i,t)
    J;

Equations
    obj
    h1(t)
    g1(i,t) 
    g2(i,t) 
    ;
    
obj.. J =E= sum((i,t), c(i)*P(i,t));
h1(t).. d(t) =E= sum(i, P(i,t));
g1(i,t)$(ord(t) > 1).. P(i,t-1) + dP_up(i) =G= P(i,t);
g2(i,t)$(ord(t) > 1).. P(i,t-1) - dP_do(i) =L= P(i,t);

P.lo(i,t) = 0;

model problema /all/;

solve problema minimizing J using LP;

Display P.l, J.l;