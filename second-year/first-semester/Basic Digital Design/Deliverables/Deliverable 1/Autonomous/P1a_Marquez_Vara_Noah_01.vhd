----------ENTITATS ENUNCIAT----------

--INVERSOR
ENTITY inversor IS
PORT (a: IN BIT; z: OUT BIT);
END inversor;

ARCHITECTURE logica of inversor IS
BEGIN
z <= NOT a;
END logica;


--AND2
ENTITY and2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica OF and2 IS
BEGIN
z <= a AND b;
END logica;

--AND3
ENTITY and3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END and3;

ARCHITECTURE logica OF and3 IS
BEGIN
z <= a AND b AND c;
END logica;

--AND4
ENTITY and4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END and4;

ARCHITECTURE logica OF and4 IS
BEGIN
z <= a AND b AND c AND d;
END logica;

--OR2
ENTITY or2 IS
PORT(a, b: IN BIT; z: OUT BIT);
END or2;

ARCHITECTURE logica OF or2 IS
BEGIN
z <= a OR b;
END logica;

--OR3
ENTITY or3 IS
PORT(a, b, c: IN BIT; z: OUT BIT);
END or3;

ARCHITECTURE logica OF or3 IS
BEGIN
z <= a OR b OR c;
END logica;

--OR4
ENTITY or4 IS
PORT(a, b, c, d: IN BIT; z: OUT BIT);
END or4;

ARCHITECTURE logica OF or4 IS
BEGIN
z <= a OR b OR c OR d;
END logica;
