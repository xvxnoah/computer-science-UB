--INVERSOR
ENTITY inversor IS
PORT (a: IN BIT; z: OUT BIT);
END inversor;

ARCHITECTURE logica OF inversor IS
BEGIN
z <= NOT a;
END logica;

ARCHITECTURE logicaretard OF inversor IS
BEGIN
z <= NOT a AFTER 3 ns;
END logicaretard;

-- PORTA AND2
ENTITY and2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica OF and2 IS
BEGIN
Z <= a AND b;
END logica;

ARCHITECTURE logicaretard OF and2 IS
BEGIN
Z <= a AND b AFTER 3 ns;
END logicaretard;

-- PORTA OR2
ENTITY or2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END or2;

ARCHITECTURE logica OF or2 IS
BEGIN
z <= a OR b;
END logica;

ARCHITECTURE logicaretard OF or2 IS
BEGIN
Z <= a OR b AFTER 3 ns;
END logicaretard;

-- PORTA NAND3
ENTITY nand3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END nand3;

ARCHITECTURE logica OF nand3 IS
BEGIN
Z <= NOT (a AND b AND c);
END logica;

ARCHITECTURE logicaretard OF nand3 IS
BEGIN
z <= NOT (a AND b AND c) AFTER 3 ns;
END logicaretard;


ENTITY mux2a1 IS
PORT(a,b: IN BIT; s: IN BIT; f: OUT BIT);
END mux2a1;

ARCHITECTURE logicaretard OF mux2a1 IS 
BEGIN
f<= (NOT s and a) OR (s AND b) AFTER 3 ns;
END logicaretard;

ARCHITECTURE ifthen OF mux2a1 IS 
BEGIN
PROCESS (s, a,b)
BEGIN
IF s='0' THEN f<=a AFTER 3 ns;
ELSE f<=b AFTER 3 ns;
END IF;
END PROCESS;
END ifthen;

ARCHITECTURE estructural OF mux2a1 IS
COMPONENT inversor IS
PORT (a: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT and2 IS
PORT (a,b: IN BIT; z: OUT BIT);
END COMPONENT;
COMPONENT or2 IS
PORT (a,b: IN BIT; z: OUT BIT);
END COMPONENT;

SIGNAL nots, sand1, sand2: BIT;

FOR DUT1: inversor USE ENTITY WORK.inversor(logicaretard);
FOR DUT2: and2 USE ENTITY WORK.and2(logicaretard);
FOR DUT3: and2 USE ENTITY WORK.and2(logicaretard);
FOR DUT4: or2 USE ENTITY WORK.or2(logicaretard);

BEGIN

DUT1: inversor PORT MAP (s, nots);
DUT2: and2 PORT MAP (a,nots,sand1);
DUT3: and2 PORT MAP (b,s,sand2);
DUT4: or2 PORT MAP (sand1,sand2,f);
END estructural;

-----FF_T
ENTITY FF_T IS
PORT(T,Clk,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_T;

ARCHITECTURE ifthen OF FF_T IS
SIGNAL qint: BIT;
BEGIN
PROCESS (T,Clk,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='1' THEN
      	IF T = '0' THEN
		qint <= qint AFTER 2 ns;
		ELSE qint <= NOT qint AFTER 2 ns;
	END IF;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;


ENTITY circuit4 IS
PORT(s,clock: IN BIT; Q2,Q1,Q0: OUT BIT);
END circuit4;

ARCHITECTURE estructural OF circuit4 IS
COMPONENT mux2a1 IS
PORT(a,b: IN BIT; s: IN BIT; f: OUT BIT);
END COMPONENT;

COMPONENT FF_T IS
PORT(T,Clk,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

COMPONENT nand3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END COMPONENT;

SIGNAL t2,t1,t0: BIT;
SIGNAL q0int,noq0int,q1int,noq1int,q2int,noq2int: BIT;
SIGNAL clear: BIT;

FOR DUT1: mux2a1 USE ENTITY WORK.mux2a1(ifthen);
FOR DUT2: mux2a1 USE ENTITY WORK.mux2a1(logicaretard);
FOR DUT3: mux2a1 USE ENTITY WORK.mux2a1(estructural);
FOR DUT4: FF_T USE ENTITY WORK.FF_T(ifthen);
FOR DUT5: FF_T USE ENTITY WORK.FF_T(ifthen);
FOR DUT6: FF_T USE ENTITY WORK.FF_T(ifthen);
FOR DUT7: nand3 USE ENTITY WORK.nand3(logicaretard);

BEGIN
DUT1: mux2a1 PORT MAP('1','0',s,t0);
DUT2: mux2a1 PORT MAP('1','0',s,t1);
DUT3: mux2a1 PORT MAP('1','0',s,t2);
DUT4: FF_T PORT MAP(t0,clock,clear,q0int,noq0int);
DUT5: FF_T PORT MAP(t1,noq0int,clear,q1int,noq1int);
DUT6: FF_T PORT MAP(t2,noq1int,clear,q2int,noq2int);
DUT7: nand3 PORT MAP(q2int,noq1int,noq0int,clear);
Q2<=q2int;
Q1<=q1int;
Q0<=q0int;
END estructural;


-- Banc de Proves

ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS
COMPONENT circuit4 IS
PORT(s,clock: IN BIT; Q2,Q1,Q0: OUT BIT);
END COMPONENT;

SIGNAL clock,s: BIT;
SIGNAL Q2, Q1, Q0: BIT;

FOR DUT1: circuit4 USE ENTITY WORK.circuit4(estructural);

BEGIN
DUT1: circuit4 PORT MAP (s,clock, Q2,Q1,Q0);

PROCESS(clock, s)
BEGIN
s <= NOT s AFTER 620 ns;
clock <= NOT clock AFTER 50 ns;
END PROCESS;
END test;


