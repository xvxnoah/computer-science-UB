-- INVERSOR
ENTITY inversor IS
PORT(a: IN BIT; z: OUT BIT);
END inversor;

ARCHITECTURE logica OF inversor IS
BEGIN
z<= NOT a;
END logica;

ARCHITECTURE logicaretard OF inversor IS
BEGIN
z<= NOT a AFTER 3 ns;
END logicaretard;

-- AND2
ENTITY and2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica OF and2 IS
BEGIN
z<= a AND b;
END logica;

ARCHITECTURE logicaretard OF and2 IS
BEGIN
z<= a AND b AFTER 3 ns;
END logicaretard;

-- AND3
ENTITY and3 IS
PORT(a,b,c: IN BIT; z: OUT BIT);
END and3;

ARCHITECTURE logica OF and3 IS
BEGIN
z<= a AND b AND c;
END logica;

ARCHITECTURE logicaretard OF and3 IS
BEGIN
z<= a AND b AND c AFTER 3 ns;
END logicaretard;

-- AND4
ENTITY and4 IS
PORT(a,b,c,d: IN BIT; z: OUT BIT);
END and4;

ARCHITECTURE logica OF and4 IS
BEGIN
z<= a AND b AND c AND d;
END logica;

ARCHITECTURE logicaretard OF and4 IS
BEGIN
z<= a AND b AND c AND d AFTER 3 ns;
END logicaretard;

-- OR2
ENTITY or2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END or2;

ARCHITECTURE logica OF or2 IS
BEGIN
z<= a OR b;
END logica;

ARCHITECTURE logicaretard OF or2 IS
BEGIN
z<= a OR b AFTER 3 ns;
END logicaretard;

-- OR3
ENTITY or3 IS
PORT(a,b,c: IN BIT; z: OUT BIT);
END or3;

ARCHITECTURE logica OF or3 IS
BEGIN
z<= a OR b OR c;
END logica;

ARCHITECTURE logicaretard OF or3 IS
BEGIN
z<= a OR b OR c AFTER 3 ns;
END logicaretard;

-- OR4
ENTITY or4 IS
PORT(a,b,c,d: IN BIT; z: OUT BIT);
END or4;

ARCHITECTURE logica OF or4 IS
BEGIN
z<= a OR b OR c OR d;
END logica;

ARCHITECTURE logicaretard OF or4 IS
BEGIN
z<= a OR b OR c OR d AFTER 3 ns;
END logicaretard;

-- XOR2
ENTITY xor2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logica OF xor2 IS
BEGIN
z<= a XOR b;
END logica;

ARCHITECTURE logicaretard OF xor2 IS
BEGIN
z<= a XOR b AFTER 3 ns;
END logicaretard;

ENTITY nand3 IS
PORT(a,b,c: IN BIT; z: OUT BIT);
END nand3;

ARCHITECTURE logica OF nand3 IS
BEGIN
z<= NOT(a AND b AND c);
END logica;

ARCHITECTURE logicaretard OF nand3 IS
BEGIN
z<= NOT(a AND b AND c) AFTER 3 ns;
END logicaretard;
