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

-- PORTA AND3
ENTITY and3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END and3;

ARCHITECTURE logica OF and3 IS
BEGIN
Z <= a AND b AND c;
END logica;

ARCHITECTURE logicaretard OF and3 IS
BEGIN
Z <= a AND b AND c AFTER 3 ns;
END logicaretard;

-- PORTA AND4
ENTITY and4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END and4;

ARCHITECTURE logica OF and4 IS
BEGIN
Z <= a AND b AND c AND d;
END logica;

ARCHITECTURE logicaretard OF and4 IS
BEGIN
Z <= a AND b AND c AND d AFTER 3 ns;
END logicaretard;

-- PORTA OR2
ENTITY or2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END or2;

ARCHITECTURE logica OF or2 IS
BEGIN
Z <= a OR b;
END logica;

ARCHITECTURE logicaretard OF or2 IS
BEGIN
Z <= a OR b AFTER 3 ns;
END logicaretard;

-- PORTA OR3
ENTITY or3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END or3;

ARCHITECTURE logica OF or3 IS
BEGIN
Z <= a OR b OR c;
END logica;

ARCHITECTURE logicaretard OF or3 IS
BEGIN
Z <= a OR b OR c AFTER 3 ns;
END logicaretard;

-- PORTA OR4
ENTITY or4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END or4;

ARCHITECTURE logica OF or4 IS
BEGIN
Z <= a OR b OR c OR d;
END logica;

ARCHITECTURE logicaretard OF or4 IS
BEGIN
Z <= a OR b OR c OR d AFTER 3 ns;
END logicaretard;


-- PORTA XOR2
ENTITY xor2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logica OF xor2 IS
BEGIN
z <= (NOT a AND B) OR (a AND NOT b);
END logica;

ARCHITECTURE logicaretard OF xor2 IS
BEGIN
z <= (NOT a AND B) OR (a AND NOT b) AFTER 3 ns;
END logicaretard;

--By the professors of DDB
