ENTITY inversor IS
PORT (a: IN BIT; z: OUT BIT);
END inversor;

ARCHITECTURE logicaretard OF inversor IS
BEGIN
	z <= not a AFTER 4 ns;
END logicaretard;

ENTITY and2 IS
PORT(a,b: IN BIT; z:OUT BIT);
END and2;

ARCHITECTURE logicaretard OF and2 IS
BEGIN
	z <= a and b AFTER 4 ns;
END logicaretard;

ENTITY xor2 IS
PORT(a,b: IN BIT; z:OUT BIT);
END xor2;

ARCHITECTURE logicaretard OF xor2 IS
BEGIN
	z <= a xor b AFTER 4 ns;
END logicaretard;

ENTITY FF_JK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_JK;

--Arquitectura per flanc de pujada
ARCHITECTURE ifthen OF FF_JK IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
ELSE
IF Pre='0' THEN qint<='1' AFTER 2 ns;
ELSE
		IF Clk'EVENT AND Clk='1' THEN
			IF J='0' AND K='0' THEN qint<=qint AFTER 2 ns;
			ELSIF J='0' AND K='1' THEN qint<='0' AFTER 2 ns;
			ELSIF J='1' AND K='0' THEN qint<='1' AFTER 2 ns;
			ELSIF J='1' AND K='1' THEN qint<= NOT qint AFTER 2 ns;
			END IF;

		END IF;
	END IF;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

--UN COP TENIM TOTES LES COMPONENTS ANEM A DISENYAR EL CIRCUIT--

ENTITY circuit_pr05 IS
	PORT(clock, x: IN BIT;
		z2,z1,z0: OUT BIT);
END circuit_pr05;

ARCHITECTURE estructural OF circuit_pr05 IS

COMPONENT FF_JK
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

COMPONENT and2 IS
PORT (a,b: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT inversor IS
PORT (a: IN BIT; z: OUT BIT);
END COMPONENT;

COMPONENT xor2 IS
PORT (a,b: IN BIT; z: OUT BIT);
END COMPONENT;

SIGNAL sxor, sinv, sand: BIT;
SIGNAL qint2, qint1, qint0: BIT;
SIGNAL noqint2, noqint1, noqint0: BIT;

FOR DUT1: and2 USE ENTITY WORK.and2(logicaretard);
FOR DUT2: inversor USE ENTITY WORK.inversor(logicaretard);
FOR DUT3: xor2 USE ENTITY WORK.xor2(logicaretard);

FOR DUT4: FF_JK USE ENTITY WORK.FF_JK(ifthen);
FOR DUT5: FF_JK USE ENTITY WORK.FF_JK(ifthen);
FOR DUT6: FF_JK USE ENTITY WORK.FF_JK(ifthen);

BEGIN 
	DUT1: and2 PORT MAP(sinv, qint1, sand);
	DUT2: inversor PORT MAP(sxor, sinv);
	DUT3: xor2 PORT MAP(x, qint0, sxor);

	--FF2
	DUT4: FF_JK PORT MAP(sand, sand, clock, '1', '1', qint2, noqint2);
	--FF1
	DUT5: FF_JK PORT MAP(sinv, sinv, clock, '1', '1', qint1, noqint1);
	--FF0
	DUT6: FF_JK PORT MAP(x, '1', clock, '1', '1', qint0, noqint0);

z2<=qint2;
z1<=qint1;
z0<=qint0;

END estructural;

--FEM BANC DE PROVES

ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS

COMPONENT circuit IS
	PORT(clock, x: IN BIT;
		z2,z1,z0: OUT BIT);
END COMPONENT;

SIGNAL clock, x: BIT;
SIGNAL z2, z1, z0: BIT;

FOR DUT1: circuit USE ENTITY WORK.circuit_pr05(estructural);

BEGIN
	DUT1: circuit PORT MAP(clock, x, z2, z1, z0);
	
	PROCESS (clock)
	BEGIN
		clock <= NOT clock AFTER 50 ns;
	END PROCESS;

	PROCESS
	BEGIN
		--començam en l'estat A

		x<='0'; --Estat C
		WAIT FOR 100 ns;

		x<='1'; --Estat D
		WAIT FOR 100 ns;

		x<='1'; --Estat E
		WAIT FOR 100 ns;

		x<='1'; --Estat F
		WAIT FOR 100 ns;

		x<='0'; --EStat E
		WAIT FOR 100 ns;

		x<='0'; --Estat G
		WAIT FOR 100 ns;

		x<='1'; --Estat H
		WAIT FOR 100 ns;	
		
	END PROCESS;

END test;



