$ontext
En este programa se resuelve el ejercicio de los tres reactores de
Van de Vusse con parámetros modificados.

Restricciones de recursos compartidos: Flujo de reactivos
$offtext

Sets
    i   "Indice reactores"  /reactor1,reactor2,reactor3/
    k   "Indice reacciones" /reaccion1,reaccion2,reaccion3/;


Parameters
    V(i)    "Volumen de los reactores (L)"
            /reactor1 11.5
            reactor2 9.5
            reactor3 12.5/
            
    Vc(i)   "Volumen de las camisas (L)"
            /reactor1 1
            reactor2 1
            reactor3 1/
    
    Ca0(i)  "Concentración de entrada de A (mol/L)"
            /reactor1 5
            reactor2 5
            reactor3 5/

    alpha(i)   "Parámetros de transmisión de calor (kJ/ºC)"
                /reactor1 1
                reactor2 1.22
                reactor3 1.42/;

Scalars
    R   "Constante de los gases (kJ/mol/K)"    /0.00831/
    p   "Densidad del agua (kg/L)"  /1/
    Cp  "Capacidad calorífica del agua (kJ/kg)" /4.184/
    T0  "Temperatura de los reactivos (ºC)" /10/
    Tc0 "Temperatura de entrada del refrigerante (ºC)"   /10/
    qmax    "Disponibilidad de reactivos (L/min)"   /5/
    qcmax   "Disponibilidad de refrigerante (L/min" /40/
    c_a "Precio de A (€/mol)"   /1/
    c_b "Precio de B (€/mol)"   /30/
    c_c "Precio de C (€/mol)"   /5/
    c_d "Precio de D (€/mol)"   /6/
    c_qc    "Precio del refrigerante (€/L)" /1/;

Table k0(i,k)    "Constantes pre-exponenciales (1/mol)"
                reaccion1   reaccion2   reaccion3
    reactor1    6.4e9       4.84e10     8.86e11
    reactor2    5.4e9       5.85e10     7.86e11
    reactor3    8.4e9       6.84e10     9.86e11;
    
Table Ea(i,k)    "Energía de activación (kJ/mol)"
                reaccion1   reaccion2   reaccion3
    reactor1    53.1        69          65
    reactor2    49.5        67          62
    reactor3    45.7        66          70;
    
Table dH(i,k)    "Energía de activación (kJ/mol)"
                reaccion1   reaccion2   reaccion3
    reactor1    -2          -4          -7
    reactor2    -2.5        -5        -6.5
    reactor3    -3          -3          -7;
    
Positive Variables

    Ca(i)   "Concentración de A (mol/L)"
            /reactor1.l 0.2
            reactor2.l 0.2
            reactor3.l 0.2/
    Cb(i)   "Concentración de B (mol/L)"
            /reactor1.l 2
            reactor2.l 2
            reactor3.l 2/
    Cc(i)   "Concentración de C (mol/L)"
            /reactor1.l 0.5
            reactor2.l 0.5
            reactor3.l 0.5/
    Cd(i)   "Concentración de D (mol/L)"
            /reactor1.l 0.6
            reactor2.l 0.6
            reactor3.l 0.6/
    T(i)    "Temperatura del reactor (ºC)"
            /reactor1.l 50
            reactor2.l 50
            reactor3.l 50/
    Tc(i)   "Temperatura de la camisa (ºC)"
            /reactor1.l 20
            reactor2.l 20
            reactor3.l 20/
    Q_tr(i) "Calor transferido reactor-camisa (kJ/min)"
    q(i)    "Caudal de reactivos (L/min)"
            /reactor1.l 2
            reactor2.l 2
            reactor3.l 1/
    qc(i)   "Caudal de refrigerante (L/min)"
            /reactor1.l 15
            reactor2.l 15
            reactor3.l 10/;
Variables
    r1(i)   "Velocidad de la reacción 1 (mol/min)"
    r2(i)   "Velocidad de la reacción 2 (mol/min)"
    r3(i)   "Velocidad de la reacción 3 (mol/min)"
    dHtot(i)"Calor total de reacción (kJ/min)"
    J(i)    "Funcion de costo individual (€/min)"
    J_total "Funcion de costo individual (€/min)";;
    
Equations
    Balance_Ca(i)       "Balance de materia Ca"
    Balance_Cb(i)       "Balance de materia Cb"
    Balance_Cc(i)       "Balance de materia Cc"
    Balance_Cd(i)       "Balance de materia Cd"
    Balance_T(i)        "Balance de energía reactor"
    Balance_Tc(i)       "Balance de energía camisa"
    cinetica1(i)        "Velocidad de reacción 1"
    cinetica2(i)        "Velocidad de reacción 2"
    cinetica3(i)        "Velocidad de reacción 3"
    dHreactor(i)        "Calor total de reacción"
    TransmisionCalor(i) "Transferencia de calor reactor-camisa"
    TotalReactivos      "Uso total de reactivos"
    TotalRefrigerante   "Uso total de refrigerante"
    CostoIndividual(i)  "Función de costo de cada reactor"
    CostoTotal          "Función de costo";
    
Balance_Ca(i).. 0 =E= q(i)*(Ca0(i) - Ca(i)) + V(i)*(-r1(i) - 2*r3(i));

Balance_Cb(i).. 0 =E= -q(i)*Cb(i) + V(i)*( r1(i) -   r2(i));

Balance_Cc(i).. 0 =E= -q(i)*Cc(i) + V(i)*( r2(i)       );

Balance_Cd(i).. 0 =E= -q(i)*Cd(i) + V(i)*(        r3(i));

Balance_T(i).. 0 =E= q(i)*p*Cp*(T0 - T(i)) - Q_tr(i) + V(i)*dHtot(i);

Balance_Tc(i).. 0 =E= qc(i)*p*Cp*(Tc0 - Tc(i)) + Q_tr(i);

cinetica1(i).. r1(i) =E= k0(i,'reaccion1')*system.exp(-Ea(i,'reaccion1')/(R*(T(i)+273.15)))*Ca(i);

cinetica2(i).. r2(i) =E= k0(i,'reaccion2')*system.exp(-Ea(i,'reaccion2')/(R*(T(i)+273.15)))*Cb(i);

cinetica3(i).. r3(i) =E= k0(i,'reaccion3')*system.exp(-Ea(i,'reaccion3')/(R*(T(i)+273.15)))*Ca(i)**2;

dHreactor(i).. dHtot(i) =E= -V(i)*(dH(i,'reaccion1')*r1(i) + dH(i,'reaccion2')*r2(i) + dH(i,'reaccion3')*r3(i));

TransmisionCalor(i).. Q_tr(i) =E= alpha(i)*(qc(i)**0.8)*(T(i) - Tc(i));

TotalReactivos.. sum(i, q(i)) =L= qmax;

TotalRefrigerante.. sum(i, qc(i)) =L= qcmax;

CostoIndividual(i).. J(i) =E= -(q(i)*(c_b*Cb(i) + c_c*Cc(i) + c_d*Cd(i) - c_a*Ca(i)) - c_qc*qc(i));

CostoTotal.. J_total =E= sum(i, J(i));
 
q.lo(i) = 0.3;
q.up(i) = 3;
qc.lo(i) = 1;
qc.up(i) = 25;
T.lo(i) = 10;
T.up(i) = 70;

model modelo /ALL/;
solve modelo minimizing J_total using NLP;
Display q.l, qc.l, T.l, Tc.l, Ca.l, Cb.l, J_total.l;
    
 