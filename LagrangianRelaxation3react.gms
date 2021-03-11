$ontext
Lagrangian relaxation with 3 CSTR reactors sharing feed and coolant
Van der Vusse reactors
--   A->B
     B->C
     2A->D
--  B desired product
--  Feed A
$offtext


Sets
    i   "Indice reactores"  /1, 2, 3/
    k   "Indice reacciones" /reac1,reac2,reac3/
    ii(i) reactores 
    ;
  
Parameters
    V(i)    "Volumen de los reactores (l)"
            /1  11.5,
             2  9.5,
             3  12.5/

    Vc(i)   "Volumen de las camisas (l)"
            /1  1,
             2  1,
             3  1/

    U(i)   "Parámetros de transmisión de calor (kJ/ºC)"
                /1  1,
                 2  1.22,
                 3  1.42/
    peso(i)  "Peso del costo de cada reactor (1%)"
                /1  1,
                 2  1,
                 3  1/             
;

Table k0(i,k)    "Constantes pre-exponenciales (1/mol)"
        reac1   reac2     reac3
    1   6.4e9   4.84e10   8.86e11
    2   5.4e9   5.85e10   7.86e11
    3   8.4e9   6.84e10   9.86e11;

Table Ea(i,k)    "Energía de activación (kJ/mol)"
        reac1   reac2   reac3
    1   53.1    69      65
    2   49.5    67      62
    3   45.7    66      70;

Table dH(i,k)    "Energía de activación (kJ/mol)"
        reac1   reac2   reac3
    1   -2      -4      -7
    2   -2.5    -5      -6.5
    3   -3      -3      -7;

Scalars
    R       "Constante de los gases (kJ/mol/K)"    /0.00831/
    rho     "Densidad del agua (kg/l)"  /1/
    Cp      "Capacidad calorífica del agua (kJ/kg)" /4.184/
    T0      "Temperatura de entrada de los reactivos (ºC)" /10/
    Tc0     "Temperatura de entrada del refrigerante (ºC)"   /10/
    Ca0     "Concentración de entrada de A (mol/l)" /5.1/
    qmax    "Disponibilidad de reactivos (l/min)"   /5/
    Frmax   "Disponibilidad de refrigerante (l/min" /40/
    p_a     "Precio de A (€/mol)"   /1/
    p_b     "Precio de B (€/mol)"   /30/
    p_c     "Precio de C (€/mol)"   /5/
    p_d     "Precio de D (€/mol)"   /6/
    p_Fr    "Precio del refrigerante (€/l)" /1/
    
    lambda_1    "Multiplicador del caudal de reactivos" /0/
    lambda_2    "Multiplicador del caudal de refrigerante" /0/

    n_iter      "Numero de iteraciones" /0/
    n_iter_max  "Numero maximo de iteraciones" /1000/
    epsilon     "Tamaño del gap maximo permitido" /1e-4/
    c           "Constante para el paso de lambda"  /1/
;

Positive Variables

    Ca(i)   "Concentrción de A (mol/l)"
            /1.l 0.2,
             2.l 0.2,
             3.l 0.2/
    Cb(i)   "Concentración de B (mol/l)"
            /1.l 2,
             2.l 2,
             3.l 2/
    Cc(i)   "Concentración de C (mol/l)"
            /1.l 0.5,
             2.l 0.5,
             3.l 0.5/
    Cd(i)   "Concentración de D (mol/l)"
            /1.l 0.6,
             2.l 0.6,
             3.l 0.6/
    T(i)    "Temperatura del reactor (ºC)"
            /1.l 50,
             2.l 50,
             3.l 50/
    Tc(i)   "Temperatura de la camisa (ºC)"
            /1.l 20,
             2.l 20,
             3.l 20/
    Q_tr(i) "Calor transferido reactor-camisa (kJ/min)"
    
    q(i)    "Caudal de reactivos (l/min)"
            /1.l 3,
             2.l 2,
             3.l 2.5/
    Fr(i)   "Caudal de refrigerante (l/min)"
            /1.l 13,
             2.l 7,
             3.l 14/;

Variables
    r1(i)    "Velocidad de la reacción 1 en el reactor i (mol/min)"
    r2(i)    "Velocidad de la reacción 1 en el reactor i (mol/min)"
    r3(i)    "Velocidad de la reacción 1 en el reactor i (mol/min)"
    dHtot(i) "Calor total de reacción (kJ/min)"
    Ji(i)    "Funcion de costo individual de cada reactor i (€/min)"
    Li(i)    "Funcion de costo de cada subproblema i (€/min)"
    z

    J_total  "Funcion de costo total (€/min)";

Equations
    Balance_Ca(i)         "Balance de materia Ca en cada reactor i"
    Balance_Cb(i)         "Balance de materia Cb en cada reactor i" 
    Balance_Cc(i)         "Balance de materia Cc en cada reactor i"
    Balance_Cd(i)         "Balance de materia Cd en cada reactor i"
    Balance_T(i)          "Balance de energía en cada reactor i"
    Balance_Tc(i)         "Balance de energía camisa en cada reactor i"
    cinetica1(i)          "Velocidad de la reacción 1 en cada reactor i"
    cinetica2(i)          "Velocidad de la reacción 1 en cada reactor i"
    cinetica3(i)          "Velocidad de la reacción 1 en cada reactor i"
    deltaH(i)             "Calor total de reacción en cada reactor i"
    TransCalor(i)         "Transferencia de calor reactor-camisa en cada reactor i"
    CostoIndividual(i)    "Función de costo de cada reactor i"
    LagrangianaLi(i)      "Funcion de costo modificada de cada subproblema i"
    Recurso1              "limitacion de caudal de producto"
    Recurso2              "limitacion de caudal de refrigerante"
    CostoTotal            "Funcion de costo del problema global"
    ;

    Balance_Ca(ii)..       0 =E= q(ii)*(Ca0 - Ca(ii)) + V(ii)*(-r1(ii) - 2*r3(ii));
    Balance_Cb(ii)..       0 =E= -q(ii)*Cb(ii) + V(ii)*( r1(ii) -   r2(ii));
    Balance_Cc(ii)..       0 =E= -q(ii)*Cc(ii) + V(ii)*( r2(ii)  );
    Balance_Cd(ii)..       0 =E= -q(ii)*Cd(ii) + V(ii)*( r3(ii));
*    Balance_T(ii)..        0 =E= q(ii)*rho*Cp*(T0 - T(ii)) - Q_tr(ii) + dHtot(ii);
    Balance_T(ii)..        0 =E= q(ii)*rho*Cp*(T0 - T(ii)) - Q_tr(ii) + V(ii)*dHtot(ii);
    Balance_Tc(ii)..       0 =E= Fr(ii)*rho*Cp*(Tc0 - Tc(ii)) + Q_tr(ii);
    cinetica1(ii)..        r1(ii) =E= k0(ii,'reac1')*exp(-Ea(ii,'reac1')/(R*(T(ii)+273.15)))*Ca(ii);
    cinetica2(ii)..        r2(ii) =E= k0(ii,'reac2')*exp(-Ea(ii,'reac2')/(R*(T(ii)+273.15)))*Cb(ii);
    cinetica3(ii)..        r3(ii) =E= k0(ii,'reac3')*exp(-Ea(ii,'reac3')/(R*(T(ii)+273.15)))*Ca(ii)**2;
*    deltaH(ii)..           dHtot(ii) =E= -V(ii)*(dH(ii,'reac1')*r1(ii) + dH(ii,'reac2')*r2(ii) + dH(ii,'reac3')*2*r3(ii));
    deltaH(ii)..           dHtot(ii) =E= -V(ii)*(dH(ii,'reac1')*r1(ii) + dH(ii,'reac2')*r2(ii) + dH(ii,'reac3')*r3(ii));
    TransCalor(ii)..       Q_tr(ii) =E= U(ii)*(Fr(ii)**0.8)*(T(ii) - Tc(ii));
    CostoIndividual(ii)..  Ji(ii) =E= -peso(ii)*(q(ii)*(p_b*Cb(ii) + p_c*Cc(ii) + p_d*Cd(ii) - p_a*Ca(ii)) - p_Fr*Fr(ii));
    LagrangianaLi(ii)..    z =E= Ji(ii) + lambda_1*q(ii) + lambda_2*Fr(ii);
    Recurso1..             sum(i, q(i)) - qmax =L= 0;
    Recurso2..             sum(i, Fr(i)) - Frmax =L= 0;
    CostoTotal..           J_total =E= sum(i, Ji(i));

* Limites de las variables de operacion
    q.lo(i) = 0.3;
    q.up(i) = 3;
    Fr.lo(i) = 1;
    Fr.up(i) = 25;
    T.lo(i) = 10;
    T.up(i) = 70;

*    lambda_1 = 402.66771;
*    lambda_2 = 42.22861;

    ii(i)= no;
    ii('1')= yes;
model subproblema1 /Balance_Ca, Balance_Cb, Balance_Cc, Balance_Cd, Balance_T, Balance_Tc,
                    cinetica1, cinetica2, cinetica3, deltaH, TransCalor, CostoIndividual, LagrangianaLi/;
    ii(i) = no;
    ii('2')= yes;
model subproblema2 /Balance_Ca, Balance_Cb, Balance_Cc, Balance_Cd, Balance_T, Balance_Tc,
                    cinetica1, cinetica2, cinetica3, deltaH, TransCalor, CostoIndividual, LagrangianaLi/;
    ii(i) = no;
    ii('3') = yes;               
model subproblema3 /Balance_Ca, Balance_Cb, Balance_Cc, Balance_Cd, Balance_T, Balance_Tc,
                    cinetica1, cinetica2, cinetica3, deltaH, TransCalor, CostoIndividual, LagrangianaLi/;

File reporte /reporte.txt/;
put reporte;
*Limitar los decimales a cinco
reporte.nd = 5;
*Delimitar por comas
*reporte.pc = 5;

Scalars
    subgradiente1  
    subgradiente2
    J_dual
    J_iter
    step
    gap
    J_dual_max /-inf/
    J_up /inf/;
    

option NLP = ipopt;

while (n_iter <= n_iter_max,

*Subproblemas

    ii(i)= no;
    ii('1')= yes;   
    solve subproblema1 minimizing z using NLP;
    Li.l(ii) = z.l;
    
    ii(i)= no;
    ii('2')= yes;     
    solve subproblema2 minimizing z using NLP;
    Li.l(ii) = z.l;
    
    ii(i)= no;
    ii('3')= yes; 
    solve subproblema3 minimizing z using NLP;
    Li.l(ii) = z.l;
    
    ii(i)= yes;
    display Li.l;
    
* Lower bound. Se evalua el dual en la solución actual
    J_dual = sum(ii, Li.l(ii)) - lambda_1*qmax - lambda_2*Frmax;
*  Se actualiza el limite inferior
    if (J_dual > J_dual_max, J_dual_max = J_dual;);
 
* Se calculan los subgradientes respecto a los dos recursos compartidos
    subgradiente1 = sum(ii, q.l(ii)) - qmax;
    subgradiente2 = sum(ii, Fr.l(ii)) - Frmax;
* Se actualiza el limite superior
    J_iter = sum(ii, Ji.l(ii));
    if (((subgradiente1 <= 0) and (subgradiente2 <= 0) and (J_iter < J_up)), J_up = J_iter;);
*  Se calcula el gap
    gap = J_up - J_dual_max;
*  Condicion de terminacion
    n_iter = n_iter + 1;  
    if(gap <= epsilon, n_iter = n_iter_max +2; );
  
* Calculo de los nuevos lambdas
    step = (1 + c) / (n_iter + c);
    lambda_1 = max(0, lambda_1 + step*subgradiente1);
    lambda_2 = max(0, lambda_2 + step*subgradiente2);
    
    
    put n_iter, lambda_1, lambda_2, J_dual_max, J_up, gap, q.l('1'), q.l('2'), q.l('3'), Fr.l('1'), Fr.l('2'), Fr.l('3') /;
    );

putclose;
Display q.l, Fr.l, T.l, Tc.l, Ca.l, Cb.l, lambda_1, lambda_2, gap;

    