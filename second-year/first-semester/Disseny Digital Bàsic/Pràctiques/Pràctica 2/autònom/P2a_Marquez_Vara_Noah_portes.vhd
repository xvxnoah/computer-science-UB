---------- PREGUNTA APARTAT 1 ----------
-- Hi ha un petit rebot perquè en temps = 200ns es produeix un canvi en els valors de 'a', 'b' i 'c', passen a valdre 0 (a i b) i 1 (c). Això
-- implica que el senyal de 'b' triga més en arribar ja que ha de passar per un inversor. Aquest minúscul temps de resposta
-- influeix en el senyal alpha i en la porta or del final, donant lloc a que en comptes d'arribar un '1' arribi un '0' a la 
-- sortida f durant 3 ns. Hem d'esperar uns 9ns (200-209ns) a que s'estabilitzi el senyal.
-- Cada 400ns podem veure repetit el mateix fenòmen (606ns, 106ns, ...).

-- COMENTARI: A l'enunciat dieu que la senyal d'A és la que ha de variar més ràpid tal i com es mostra a l'exemple. Però a l'exemple dieu que 
-- la senyal d'A ha de variar cada 200 ns, i considero que si ha de variar més ràpid hauria de ser amb els 50ns que mencioneu a la tasca. També
-- he vist que dieu que variïn les senyals cada 50ns (50, 100, 150, 200), però a l'exemple es va doblant el nombre per cada sortida 
-- (50, 100, 200, 400). 

---------- PORTES ----------

-- INVERSOR
ENTITY inversor IS
PORT(a: IN BIT; Z: OUT BIT);
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
