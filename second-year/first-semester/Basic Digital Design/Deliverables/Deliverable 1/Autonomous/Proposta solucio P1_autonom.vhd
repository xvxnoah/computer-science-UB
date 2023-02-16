--INVERSOR
ENTITY inversor IS
PORT (a: IN BIT; z: OUT BIT);
END inversor;

ARCHITECTURE logica OF inversor IS
BEGIN
z <= NOT a;
END logica;


-- PORTA AND2
ENTITY and2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica OF and2 IS
BEGIN
Z <= a AND b;
END logica;

-- PORTA AND3
ENTITY and3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END and3;

ARCHITECTURE logica OF and3 IS
BEGIN
Z <= a AND b AND c;
END logica;


-- PORTA AND4
ENTITY and4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END and4;

ARCHITECTURE logica OF and4 IS
BEGIN
Z <= a AND b AND c AND d;
END logica;

-- PORTA OR2
ENTITY or2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END or2;

ARCHITECTURE logica OF or2 IS
BEGIN
Z <= a OR b;
END logica;

-- PORTA OR3
ENTITY or3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END or3;

ARCHITECTURE logica OF or3 IS
BEGIN
Z <= a OR b OR c;
END logica;


-- PORTA OR4
ENTITY or4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END or4;

ARCHITECTURE logica OF or4 IS
BEGIN
Z <= a OR b OR c OR d;
END logica;


--BANC DE PROVES
ENTITY banc_de_proves IS
END banc_de_proves;

ARCHITECTURE test OF banc_de_proves IS
COMPONENT inversor
PORT (a: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT and2
PORT (a,b: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT or2
PORT (a,b: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT and3
PORT (a,b,c: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT or3
PORT (a,b,c: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT and4
PORT (a,b,c,d: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT or4
PORT (a,b,c,d: IN BIT; z: OUT BIT);
END COMPONENT;

SIGNAL ent1, ent2, ent3, ent4: BIT;
SIGNAL sinv: BIT;
SIGNAL sand2, sand3, sand4: BIT; 
SIGNAL sor2, sor3, sor4: BIT; 

FOR DUT1: inversor USE ENTITY WORK.inversor(logica);
FOR DUT2: and2 USE ENTITY WORK.and2(logica);
FOR DUT3: and3 USE ENTITY WORK.and3(logica);
FOR DUT4: and4 USE ENTITY WORK.and4(logica);
FOR DUT5: or2 USE ENTITY WORK.or2(logica);
FOR DUT6: or3 USE ENTITY WORK.or3(logica);
FOR DUT7: or4 USE ENTITY WORK.or4(logica);

BEGIN
DUT1: inversor PORT MAP (ent1,sinv);
DUT2: and2 PORT MAP (ent1,ent2,sand2);
DUT3: and3 PORT MAP (ent1,ent2,ent3,sand3);
DUT4: and4 PORT MAP (ent1,ent2,ent3,ent4,sand4);
DUT5: or2 PORT MAP (ent1,ent2,sor2);
DUT6: or3 PORT MAP (ent1,ent2,ent3,sor3);
DUT7: or4 PORT MAP (ent1,ent2,ent3,ent4,sor4);


PROCESS (ent1,ent2,ent3,ent4)
BEGIN
ent1<=NOT ent1 AFTER 50 ns;
ent2<=NOT ent2 AFTER 100 ns;
ent3<=NOT ent3 AFTER 200 ns;
ent4<=NOT ent4 AFTER 400 ns;
END PROCESS;
END test;
