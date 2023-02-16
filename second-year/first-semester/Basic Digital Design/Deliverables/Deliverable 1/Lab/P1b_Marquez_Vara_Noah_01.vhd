--ENTITY INVERSOR:
ENTITY inversor IS 
 	PORT( a: IN BIT; b: OUT BIT);
END inversor;

--ARCHITECTURES OF INVERSOR:
ARCHITECTURE logica OF inversor IS
BEGIN
	b <= NOT a;
END logica;

ARCHITECTURE logicaretard OF inversor IS
BEGIN
	b <= NOT a after 3 ns;
END logicaretard;

--ENTITY AND2:
ENTITY and2 IS
 	PORT( a,b: IN BIT; z: OUT BIT);
END and2;

--ARCHITECTURES OF AND2:
ARCHITECTURE logica OF and2 IS
BEGIN
	z <= a AND b;
END logica;

ARCHITECTURE logicaretard of and2 IS
BEGIN
	z <= a AND b after 3 ns;
END logicaretard;

--ENTITY AND3:
ENTITY and3 IS
	PORT( a, b, c: IN BIT; z: OUT BIT);
END and3;

--ARCHITECTURES OF AND3:
ARCHITECTURE logica of and3 IS
BEGIN
 	z <= a AND b AND c;
END logica;

ARCHITECTURE logicaretard of and3 IS
BEGIN
	z <= a AND b AND c after 3 ns;
END logicaretard;

-- ENTITY AND4
ENTITY and4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END and4;

--ARCHITECTURES OF AND4:
ARCHITECTURE logica OF and4 IS
BEGIN
z <= a AND b AND c AND d;
END logica;

ARCHITECTURE logicaretard of and4 IS
BEGIN
	z <= a AND b AND c AND d after 3 ns;
END logicaretard;

--ENTITY OR2:
ENTITY or2 IS
	PORT( a, b: IN BIT; z: OUT BIT);
END or2;

--ARCHITECTURES OF OR2:
ARCHITECTURE logica OF or2 IS
BEGIN
	z <= a OR b;
END logica;

ARCHITECTURE logicaretard OF or2 IS
BEGIN
	z <= a OR b after 3 ns;
END logicaretard;

--ENTITY OR3:
ENTITY or3 IS
	PORT( a, b, c: IN BIT; z: OUT BIT);
END or3;

--ARCHITECTURES OF OR3:
ARCHITECTURE logica OF or3 IS
BEGIN
 	z <= a OR b OR c;
END logica;

ARCHITECTURE logicaretard OF or3 IS
BEGIN
	z <= a OR b OR c after 3 ns;
END logicaretard;

--ENTITY OR4
ENTITY or4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END or4;

--ARCHITECTURES OF OR4:
ARCHITECTURE logica OF or4 IS
BEGIN
z <= a OR b OR c OR d;
END logica;

ARCHITECTURE logicaretard OF or4 IS
BEGIN
	z <= a OR b OR c OR d after 3 ns;
END logicaretard;

--ENTITY XOR2:
ENTITY xor2 IS
	PORT (a, b: IN BIT; z: OUT BIT);
END xor2;

--ARCHITECTURES OF XOR2:
ARCHITECTURE logica of xor2 IS
BEGIN
	z <= a XOR b;
END logica;

ARCHITECTURE logicaretard of xor2 IS
BEGIN
	z <= a XOR b after 3 ns;
END logicaretard;