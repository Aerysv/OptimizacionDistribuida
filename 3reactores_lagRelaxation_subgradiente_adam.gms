$ontext
3 reactores relajación lagrangiana (descomposición dual)

Master resuelto con ADAM. Es un algoritmo para optimización estocástica
basado en el gradiente.

Ver: ADAM: A Method for Stochatic Optimization (2015)
$offtext
Sets
    i   "Indice reactores"  /1, 2, 3/
    k   "Indice reacciones" /reaccion1,reaccion2,reaccion3/;

Parameters
    V(i)    "Volumen de los reactores (L)"
            /1 11.5,
             2 9.5,
             3 12.5/

    Vc(i)   "Volumen de las camisas (L)"
            /1 1,
             2 1,
             3 1/

    Ca0(i)  "Concentración de entrada de A (mol/L)"
            /1 5,
             2 5,
             3 5/

    alpha(i)   "Parámetros de transmisión de calor (kJ/ºC)"
                /1 1,
                 2 1.22,
                 3 1.42/
    q0(i)    "Caudal de reactivos (L/min)"
            /1 1,
             2 3,
             3 2/
    qc0(i)   "Caudal de refrigerante (L/min)"
            /1 14,
             2 25,
             3 10/;
    ;

Scalars
    R   "Constante de los gases (kJ/mol/K)"    /0.00831/
    p   "Densidad del agua (kg/L)"  /1/
    Cp  "Capacidad calorífica del agua (kJ/kg)" /4.184/
    T0  "Temperatura de los reactivos (ºC)" /10/
    Tc0 "Temperatura de entrada del refrigerante (ºC)"   /10/
    qmax    "Disponibilidad de reactivos (L/min)"   /5/
    qcmax   "Disponibilidad de refrigerante (L/min" /40/
    c_a     "Precio de A (€/mol)"   /1/
    c_b     "Precio de B (€/mol)"   /30/
    c_c     "Precio de C (€/mol)"   /5/
    c_d     "Precio de D (€/mol)"   /6/
    c_qc    "Precio del refrigerante (€/L)" /1/

    lambda_1    "Multiplizador del caudal de reactivos" /10/
    lambda_2    "Multiplizador del caudal de refrigerante6" /1/
    n_iter      "Numero de iteraciones" /0/
    step_size   "Tamño del paso del problema maestro" /0/;

Table k0(i,k)    "Constantes pre-exponenciales (1/mol)"
        reaccion1   reaccion2   reaccion3
    1   6.4e9       4.84e10     8.86e11
    2   5.4e9       5.85e10     7.86e11
    3   8.4e9       6.84e10     9.86e11;

Table Ea(i,k)    "Energía de activación (kJ/mol)"
        reaccion1   reaccion2   reaccion3
    1   53.1        69          65
    2   49.5        67          62
    3   45.7        66          70;

Table dH(i,k)    "Energía de activación (kJ/mol)"
        reaccion1   reaccion2   reaccion3
    1   -2          -4          -7
    2   -2.5        -5          -6.5
    3   -3          -3          -7;

Positive Variables

    Ca(i)   "Concentrción de A (mol/L)"
            /1.l 0.2,
             2.l 0.2,
             3.l 0.2/
    Cb(i)   "Concentración de B (mol/L)"
            /1.l 2,
             2.l 2,
             3.l 2/
    Cc(i)   "Concentración de C (mol/L)"
            /1.l 0.5,
             2.l 0.5,
             3.l 0.5/
    Cd(i)   "Concentración de D (mol/L)"
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
    q(i)    "Caudal de reactivos (L/min)"
            /1.l 3,
             2.l 2,
             3.l 2.5/
    qc(i)   "Caudal de refrigerante (L/min)"
            /1.l 13,
             2.l 7,
             3.l 14/;
Variables
    r1(i)   "Velocidad de la reacción 1 (mol/min)"
    r2(i)   "Velocidad de la reacción 2 (mol/min)"
    r3(i)   "Velocidad de la reacción 3 (mol/min)"
    dHtot(i)"Calor total de reacción (kJ/min)"
    J1      "Funcion de costo individual (€/min)"
    J2      "Funcion de costo individual (€/min)"
    J3      "Funcion de costo individual (€/min)"
    J_total "Funcion de costo individual (€/min)";

Equations
    Balance_Ca1         "Balance de materia Ca"
    Balance_Ca2         "Balance de materia Ca"
    Balance_Ca3         "Balance de materia Ca"
    Balance_Cb1         "Balance de materia Cb"
    Balance_Cb2         "Balance de materia Cb"
    Balance_Cb3         "Balance de materia Cb"
    Balance_Cc1         "Balance de materia Cc"
    Balance_Cc2         "Balance de materia Cc"
    Balance_Cc3         "Balance de materia Cc"
    Balance_Cd1         "Balance de materia Cd"
    Balance_Cd2         "Balance de materia Cd"
    Balance_Cd3         "Balance de materia Cd"
    Balance_T1          "Balance de energía reactor"
    Balance_T2          "Balance de energía reactor"
    Balance_T3          "Balance de energía reactor"
    Balance_Tc1         "Balance de energía camisa"
    Balance_Tc2         "Balance de energía camisa"
    Balance_Tc3         "Balance de energía camisa"
    cinetica11          "Velocidad de reacción 1"
    cinetica12          "Velocidad de reacción 1"
    cinetica13          "Velocidad de reacción 1"
    cinetica21          "Velocidad de reacción 2"
    cinetica22          "Velocidad de reacción 2"
    cinetica23          "Velocidad de reacción 2"
    cinetica31          "Velocidad de reacción 3"
    cinetica32          "Velocidad de reacción 3"
    cinetica33          "Velocidad de reacción 3"
    dH1                 "Calor total de reacción"
    dH2                 "Calor total de reacción"
    dH3                 "Calor total de reacción"
    TransmisionCalor1   "Transferencia de calor reactor-camisa"
    TransmisionCalor2   "Transferencia de calor reactor-camisa"
    TransmisionCalor3   "Transferencia de calor reactor-camisa"
    CostoIndividual1    "Función de costo de cada reactor"
    CostoIndividual2    "Función de costo de cada reactor"
    CostoIndividual3    "Función de costo de cada reactor"
    CostoTotal;

Balance_Ca1..       0 =E= q('1')*(Ca0('1') - Ca('1')) + V('1')*(-r1('1') - 2*r3('1'));
Balance_Cb1..       0 =E= -q('1')*Cb('1') + V('1')*( r1('1') -   r2('1'));
Balance_Cc1..       0 =E= -q('1')*Cc('1') + V('1')*( r2('1')       );
Balance_Cd1..       0 =E= -q('1')*Cd('1') + V('1')*(        r3('1'));
Balance_T1..        0 =E= q('1')*p*Cp*(T0 - T('1')) - Q_tr('1') + V('1')*dHtot('1');
Balance_Tc1..       0 =E= qc('1')*p*Cp*(Tc0 - Tc('1')) + Q_tr('1');
cinetica11..        r1('1') =E= k0('1','reaccion1')*system.exp(-Ea('1','reaccion1')/(R*(T('1')+273.15)))*Ca('1');
cinetica21..        r2('1') =E= k0('1','reaccion2')*system.exp(-Ea('1','reaccion2')/(R*(T('1')+273.15)))*Cb('1');
cinetica31..        r3('1') =E= k0('1','reaccion3')*system.exp(-Ea('1','reaccion3')/(R*(T('1')+273.15)))*Ca('1')**2;
dH1..               dHtot('1') =E= -V('1')*(dH('1','reaccion1')*r1('1') + dH('1','reaccion2')*r2('1') + dH('1','reaccion3')*r3('1'));
TransmisionCalor1.. Q_tr('1') =E= alpha('1')*(qc('1')**0.8)*(T('1') - Tc('1'));
CostoIndividual1..  J1 =E= -(q('1')*(c_b*Cb('1') + c_c*Cc('1') + c_d*Cd('1') - c_a*Ca('1')) - c_qc*qc('1')) + lambda_1*q('1')/qmax + lambda_2*qc('1')/qcmax;

Balance_Ca2..       0 =E= q('2')*(Ca0('2') - Ca('2')) + V('2')*(-r1('2') - 2*r3('2'));
Balance_Cb2..       0 =E= -q('2')*Cb('2') + V('2')*( r1('2') -   r2('2'));
Balance_Cc2..       0 =E= -q('2')*Cc('2') + V('2')*( r2('2')       );
Balance_Cd2..       0 =E= -q('2')*Cd('2') + V('2')*(        r3('2'));
Balance_T2..        0 =E= q('2')*p*Cp*(T0 - T('2')) - Q_tr('2') + V('2')*dHtot('2');
Balance_Tc2..       0 =E= qc('2')*p*Cp*(Tc0 - Tc('2')) + Q_tr('2');
cinetica12..        r1('2') =E= k0('2','reaccion1')*system.exp(-Ea('2','reaccion1')/(R*(T('2')+273.15)))*Ca('2');
cinetica22..        r2('2') =E= k0('2','reaccion2')*system.exp(-Ea('2','reaccion2')/(R*(T('2')+273.15)))*Cb('2');
cinetica32..        r3('2') =E= k0('2','reaccion3')*system.exp(-Ea('2','reaccion3')/(R*(T('2')+273.15)))*Ca('2')**2;
dH2..               dHtot('2') =E= -V('2')*(dH('2','reaccion1')*r1('2') + dH('2','reaccion2')*r2('2') + dH('2','reaccion3')*r3('2'));
TransmisionCalor2.. Q_tr('2') =E= alpha('2')*(qc('2')**0.8)*(T('2') - Tc('2'));
CostoIndividual2..  J2 =E= -(q('2')*(c_b*Cb('2') + c_c*Cc('2') + c_d*Cd('2') - c_a*Ca('2')) - c_qc*qc('2')) + lambda_1*q('2')/qmax + lambda_2*qc('2')/qcmax;

Balance_Ca3..       0 =E= q('3')*(Ca0('3') - Ca('3')) + V('3')*(-r1('3') - 2*r3('3'));
Balance_Cb3..       0 =E= -q('3')*Cb('3') + V('3')*( r1('3') -   r2('3'));
Balance_Cc3..       0 =E= -q('3')*Cc('3') + V('3')*( r2('3')       );
Balance_Cd3..       0 =E= -q('3')*Cd('3') + V('3')*(        r3('3'));
Balance_T3..        0 =E= q('3')*p*Cp*(T0 - T('3')) - Q_tr('3') + V('3')*dHtot('3');
Balance_Tc3..       0 =E= qc('3')*p*Cp*(Tc0 - Tc('3')) + Q_tr('3');
cinetica13..        r1('3') =E= k0('3','reaccion1')*system.exp(-Ea('3','reaccion1')/(R*(T('3')+273.15)))*Ca('3');
cinetica23..        r2('3') =E= k0('3','reaccion2')*system.exp(-Ea('3','reaccion2')/(R*(T('3')+273.15)))*Cb('3');
cinetica33..        r3('3') =E= k0('3','reaccion3')*system.exp(-Ea('3','reaccion3')/(R*(T('3')+273.15)))*Ca('3')**2;
dH3..               dHtot('3') =E= -V('3')*(dH('3','reaccion1')*r1('3') + dH('3','reaccion2')*r2('3') + dH('3','reaccion3')*r3('3'));
TransmisionCalor3.. Q_tr('3') =E= alpha('3')*(qc('3')**0.8)*(T('3') - Tc('3'));
CostoIndividual3..  J3 =E= -(q('3')*(c_b*Cb('3') + c_c*Cc('3') + c_d*Cd('3') - c_a*Ca('3')) - c_qc*qc('3')) + lambda_1*q('3')/qmax + lambda_2*qc('3')/qcmax;

CostoTotal.. J_total =E= J1 + J2 + J3 - lambda_1*sum(i, q(i))/qmax - lambda_2*sum(i, qc(i))/qcmax;

q.lo(i) = 0.3;
q.up(i) = 3;
qc.lo(i) = 1;
qc.up(i) = 25;
T.lo(i) = 10;
T.up(i) = 70;

model subproblema1 /Balance_Ca1, Balance_Cb1, Balance_Cc1, Balance_Cd1, Balance_T1, Balance_Tc1,
                    cinetica11, cinetica21, cinetica31, dH1, TransmisionCalor1, CostoIndividual1/;
model subproblema2 /Balance_Ca2, Balance_Cb2, Balance_Cc2, Balance_Cd2, Balance_T2, Balance_Tc2,
                    cinetica12, cinetica22, cinetica32, dH2, TransmisionCalor2, CostoIndividual2/;
model subproblema3 /Balance_Ca3, Balance_Cb3, Balance_Cc3, Balance_Cd3, Balance_T3, Balance_Tc3,
                    cinetica13, cinetica23, cinetica33, dH3, TransmisionCalor3, CostoIndividual3/;
model global /all/;

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
    norma2
    J_up /inf/
    m_1 /1/
    m_2 /1/
    v_1 /1/
    v_2 /1/
    m_1_h
    m_2_h
    v_1_h
    v_2_h
    beta_1 /0.9/
    beta_2 /0.999/
    epsilon /1e-8/;
    
Parameters
    q_temp(i)
    qc_temp(i);
    
option NLP = ipopt;

step_size = 1;

lambda_1 = 10;
lambda_2 = 1;

while (n_iter < 10000,

*Subproblemas
    solve subproblema1 minimizing J1 using NLP;
    solve subproblema2 minimizing J2 using NLP;
    solve subproblema3 minimizing J3 using NLP;
    
* Lower bound. Se evalua el dual en la solución actual
    J_dual = J1.l + J2.l + J3.l - lambda_1 - lambda_2;

*Master
* Actualizar el contador de iteraciones
    n_iter = n_iter + 1;
* Calcular el subgradiente
    subgradiente1 = (sum(i, q.l(i)) - qmax)/qmax;
    subgradiente2 = (sum(i, qc.l(i)) - qcmax)/qcmax;
* Update biased first moment estimate
    m_1 = beta_1*m_1 + (1 - beta_1)*subgradiente1;
    m_2 = beta_1*m_2 + (1 - beta_1)*subgradiente2;
* Update biased second raw moment estimate
    v_1 = beta_2*v_1 + (1 - beta_2)*sqr(subgradiente1);
    v_2 = beta_2*v_2 + (1 - beta_2)*sqr(subgradiente2);
* Compute bias-corrected first moment estimate
    m_1_h = m_1/(1 - power(beta_1, n_iter));
    m_2_h = m_2/(1 - power(beta_1, n_iter));
* Compute bias-corrected second raw moment estimate;
    v_1_h = v_1/(1 - power(beta_2, n_iter));
    v_2_h = v_2/(1 - power(beta_2, n_iter));
* Update the multipliers
    lambda_1 = max(0, lambda_1 + step_size*m_1_h/(sqrt(v_1_h) + epsilon ) );
    lambda_2 = max(0, lambda_2 + step_size*m_2_h/(sqrt(v_2_h) + epsilon ) );

    norma2 = sqrt( sqr(subgradiente1) + sqr(subgradiente2) );
* Convergencia
    if (norma2 < 1e-6,
        break
        );        
    
    put n_iter, q.l('1'), q.l('2'), q.l('3'), qc.l('1'), qc.l('2'), qc.l('3'), lambda_1, lambda_2, J_dual, norma2 /;
    );

putclose;
Display q.l, qc.l, T.l, Tc.l, Ca.l, Cb.l, J1.l, J2.l, J3.l, lambda_1, lambda_2;

