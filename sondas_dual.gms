Sets
    i   "Componentes"   /formula, agua, zumo, azucar/
    j   "Fabricas"      /1, 2, 3/;

Scalars
    formula_max "Cantidad disponible de fórmula (m3)" /22/
    demanda     "Cantidad de soda a producir (m3)" /1000/
    n_iter      "Número de iteraciones" /0/
    step_size   "tamaño del paso" /0/
    lambda_1    "Multiplicador formula" /0/
    lambda_2    "Multiplicador demanda" /0/;

Parameters
    h_max(j)    "Contenido máximo de carbohidrato"
                /1 24.0,
                 2 27.5,
                 3 30.0/
    v_min(j)    "Contenido mínimo de vitáminas"
                /1 19.5,
                 2 22.0,
                 3 22.0/;
                 
Table   p(i,j)  "Costos de los componentes"
                    1   2   3
        formula     5   5   5
        agua        2   2.2 2.1
        zumo        3   3.3 3.1
        azucar      4   4.4 4.1;
Table   h(i,j)  "Contenido de carbohidratos"
                    1       2       3
        formula     0.10    0.10    0.10
        agua        0.07    0.07    0.07
        zumo        0.08    0.08    0.08
        azucar      0.09    0.09    0.09;

Table   v(i,j)  "Contenido de vitáminas"
                    1       2       3
        formula     0.10    0.10    0.10
        agua        0.05    0.05    0.05
        zumo        0.07    0.07    0.07
        azucar      0.08    0.08    0.08;
    
Positive Variable x(i,j)    "Item i en la fabrica j";

Variables
    J1
    J2
    J3
    J_total
    J1_org
    J2_org
    J3_org;

Equations
    obj1
    obj2
    obj3
    objT
    car1
    car2
    car3
    vit1
    vit2
    vit3
    res1
    res2
    res3
    res4
    res5
    res6
    res7
    res8
    res9
    re10
    re11
    re12
    obj1_org
    obj2_org
    obj3_org
    dis_for
    demanda_total;
    
obj1.. J1 =E= sum(i, p(i,'1')*x(i,'1')) + lambda_1*x('formula','1')/formula_max + lambda_2*sum(i, x(i,'1'))/demanda;
obj1_org.. J1_org =E= sum(i, p(i,'1')*x(i,'1'));
car1.. sum(i, h(i,'1')*x(i,'1')) =L= h_max('1');
vit1.. sum(i, v(i,'1')*x(i,'1')) =G= v_min('1');
res1.. 0.02*sum(i, x(i,'1')) =L= x('formula','1');
res2.. 0.20*sum(i, x(i,'1')) =L= x('zumo','1');
res7.. 0.04*sum(i, x(i,'1')) =G= x('formula','1');
res8.. 0.30*sum(i, x(i,'1')) =G= x('zumo','1');

obj2.. J2 =E= sum(i, p(i,'2')*x(i,'2')) + lambda_1*x('formula','2')/formula_max + lambda_2*sum(i, x(i,'2'))/demanda;
obj2_org.. J2_org =E= sum(i, p(i,'2')*x(i,'2'));
car2.. sum(i, h(i,'2')*x(i,'2')) =L= h_max('2');
vit2.. sum(i, v(i,'2')*x(i,'2')) =G= v_min('2');
res3.. 0.02*sum(i, x(i,'2')) =L= x('formula','2');
res4.. 0.20*sum(i, x(i,'2')) =L= x('zumo','2');
res9.. 0.04*sum(i, x(i,'2')) =G= x('formula','2');
re10.. 0.30*sum(i, x(i,'2')) =G= x('zumo','2');

obj3.. J3 =E= sum(i, p(i,'3')*x(i,'3')) + lambda_1*x('formula','3')/formula_max + lambda_2*sum(i, x(i,'3'))/demanda;
obj3_org.. J3_org =E= sum(i, p(i,'3')*x(i,'3'));
car3.. sum(i, h(i,'3')*x(i,'3')) =L= h_max('3');
vit3.. sum(i, v(i,'3')*x(i,'3')) =G= v_min('3');
res5.. 0.02*sum(i, x(i,'3')) =L= x('formula','3');
res6.. 0.20*sum(i, x(i,'3')) =L= x('zumo','3');
re11.. 0.04*sum(i, x(i,'3')) =G= x('formula','3');
re12.. 0.30*sum(i, x(i,'3')) =G= x('zumo','3');

dis_for.. sum(j, x('formula',j)) =L= formula_max;
demanda_total.. sum((i,j), x(i,j)) =E= demanda;
objT.. J_total =E= J1 + J2 + J3;



Models
    subproblema1 /obj1, car1, vit1, res1, res2, res7, res8, obj1_org/
    subproblema2 /obj2, car2, vit2, res3, res4, res9, re10, obj2_org/
    subproblema3 /obj3, car3, vit3, res5, res6, re11, re12, obj3_org/;

File reporte /reporte.txt/;
put reporte;
reporte.nd = 4;
     
lambda_1 = 80;
lambda_2 = 1200;

Scalars
    subgradiente1
    subgradiente2;

while (n_iter < 10000,
    n_iter = n_iter + 1;
    
*    step_size = 100/(n_iter**0.5);
    step_size = 100/n_iter;
*    step_size = 1/(1+500*n_iter);
    solve subproblema1 minimizing J1 using LP;
    solve subproblema2 minimizing J2 using LP;
    solve subproblema3 minimizing J3 using LP;
    
    subgradiente1 = (sum(j, x.l('formula',j)) - formula_max)/formula_max;
    subgradiente2 = (sum((i,j), x.l(i,j)) - demanda)/demanda;

    lambda_1 = lambda_1 + step_size*subgradiente1;
    lambda_2 = lambda_2 + step_size*subgradiente2;
    
    put n_iter, lambda_1, lambda_2, J1_org.l, J2_org.l, J3_org.l, sum(j, x.l('formula',j)), sum((i,j), x.l(i,j)) /;
);
putclose;

Display x.l;
Display J1_org.l, J2_org.l, J3_org.l;