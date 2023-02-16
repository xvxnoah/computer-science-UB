ENTITY funcio IS
PORT (a,b,c,d: IN BIT; f: OUT BIT);
END funcio;

ARCHITECTURE logica OF funcio IS
BEGIN
f <= (a AND c AND (a XOR d)) OR (NOT b AND c);
END logica;


ARCHITECTURE logicaretard OF funcio IS
BEGIN
f <= (a AND c AND (a XOR d)) OR (NOT b AND c) AFTER 3 ns;
END logicaretard;

ARCHITECTURE estructural OF funcio IS

COMPONENT inversor IS
PORT(a: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT or2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT and2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT and3 IS
PORT(a,b,c: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT xor2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

SIGNAL sxor, sand1, notb, sand2: BIT;

FOR DUT1: xor2 USE ENTITY WORK.xor2(logica);
FOR DUT2: and3 USE ENTITY WORK.and3(logica);
FOR DUT3: inversor USE ENTITY WORK.inversor(logica);
FOR DUT4: and2 USE ENTITY WORK.and2(logica);
FOR DUT5: or2 USE ENTITY WORK.or2(logica);
BEGIN
	DUT1: xor2 PORT MAP(a,d,sxor);
	DUT2: and3 PORT MAP(a,c,sxor,sand1);
	DUT3: inversor PORT MAP(b, notb);
	DUT4: and2 PORT MAP(notb,c,sand2);
	DUT5: or2 PORT MAp(sand1,sand2,f);
END estructural;

ARCHITECTURE estructural_R OF funcio IS
--here I am adding another comment, meaningless by the way...
COMPONENT inversor IS
PORT(a: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT or2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT and2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT and3 IS
PORT(a,b,c: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT xor2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END COMPONENT;

SIGNAL sxor, sand1, notb, sand2: BIT;

FOR DUT1: xor2 USE ENTITY WORK.xor2(logicaretard);
FOR DUT2: and3 USE ENTITY WORK.and3(logicaretard);
FOR DUT3: inversor USE ENTITY WORK.inversor(logicaretard);
FOR DUT4: and2 USE ENTITY WORK.and2(logicaretard);
FOR DUT5: or2 USE ENTITY WORK.or2(logicaretard);
BEGIN
	DUT1: xor2 PORT MAP(a,d,sxor);
	DUT2: and3 PORT MAP(a,c,sxor,sand1);
	DUT3: inversor PORT MAP(b, notb);
	DUT4: and2 PORT MAP(notb,c,sand2);
	DUT5: or2 PORT MAp(sand1,sand2,f);
END estructural_R;

--This is just a comment...
ENTITY bancdeproves IS
END bancdeproves;

ARCHITECTURE test_de_proves OF bancdeproves IS
COMPONENT funcio IS
PORT(a,b,c,d: IN BIT; f: OUT BIT);
END COMPONENT;

SIGNAL entA, entB, entC, entD, s_logica, s_logicaretard, s_estructural, s_estructural_R: BIT;
FOR DUT1: funcio USE ENTITY WORK.funcio(logica);
FOR DUT2: funcio USE ENTITY WORK.funcio(logicaretard);
FOR DUT3: funcio USE ENTITY WORK.funcio(estructural);
FOR DUT4: funcio USE ENTITY WORK.funcio(estructural_R);

BEGIN
	DUT1: funcio PORT MAP(entA, entB, entC, entD, s_logica);
	DUT2: funcio PORT MAP(entA, entB, entC, entD, s_logicaretard);
	DUT3: funcio PORT MAP(entA, entB, entC, entD, s_estructural);
	DUT4: funcio PORT MAP(entA, entB, entC, entD, s_estructural_R);

PROCESS (entA, entB, entC, entD)
	BEGIN
		entA <= NOT entA AFTER 50 ns;
		entB <= NOT entB AFTER 100 ns;
		entC <= NOT entC AFTER 200 ns;
		entD <= NOT entD AFTER 400 ns;
	END PROCESS;
END test_de_proves;


--By the professors of DDB
