-------------- PORTES NECESSARIES --------------

--INVERSOR--
ENTITY inversor IS
	PORT (a: IN BIT; z: OUT BIT);
END inversor;

ARCHITECTURE logica of inversor IS
	BEGIN
		z <= NOT a;
END logica;

ARCHITECTURE logicaretard of inversor IS
	BEGIN
		z <= NOT a AFTER 3 ns;
END logicaretard;


--AND2--
ENTITY and2 IS
	PORT(a, b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica OF and2 IS
	BEGIN
		z <= a AND b;
END logica;

ARCHITECTURE logicaretard OF and2 IS
	BEGIN
		z <= a AND b AFTER 3 ns;
END logicaretard;


--XOR2--
ENTITY xor2 IS
	PORT(a, b: IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logica OF xor2 IS
	BEGIN
		z <= a XOR b;
END logica;

ARCHITECTURE logicaretard OF xor2 IS
	BEGIN
		z <= a XOR b AFTER 3 ns;
END logicaretard;

---------- BIESTABLE FF JK FLANC PUJADA ----------
ENTITY FF_JK IS
	PORT(J,K,Clk: IN BIT; Q: OUT BIT);
END FF_JK;


ARCHITECTURE ifthen OF FF_JK IS

	SIGNAL qint: BIT;
	BEGIN
		PROCESS (J,K,Clk)
		BEGIN
			IF Clk'EVENT AND Clk = '1' THEN
				IF J = '0' AND K='0' THEN qint <= qint AFTER 3 ns;
				ELSIF J = '0' AND K = '1' THEN qint <= '0' AFTER 3 ns;
				ELSIF J = '1' AND K = '0' THEN qint <= '1' AFTER 3 ns;
				ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 3 ns;
				END IF;
			END IF;
		END PROCESS;
	
	Q <= qint;

END ifthen;


---------- CIRCUIT PRÀCTICA 5 ----------
ENTITY circuit_pr05 IS
	PORT(X,clock: IN BIT; Z2,Z1,Z0: OUT BIT);
END circuit_pr05;


ARCHITECTURE estructural OF circuit_pr05 IS
	COMPONENT porta_inversor IS
		PORT (a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and2 IS
		PORT(a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_xor2 IS
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT flipflopJK IS
		PORT(J,K,Clk: IN BIT; Q: OUT BIT);
	END COMPONENT;

	SIGNAL Q2int, Q1int, Q0int, alfa, notalfa, notalfaandQ1: BIT;

	FOR DUTFF2: flipflopJK USE ENTITY WORK.FF_JK(ifthen);
	FOR DUTFF1: flipflopJK USE ENTITY WORK.FF_JK(ifthen);
	FOR DUTFF0: flipflopJK USE ENTITY WORK.FF_JK(ifthen);
	FOR DUTINV: porta_inversor USE ENTITY WORK.inversor(logicaretard);
	FOR DUTAND: porta_and2 USE ENTITY WORK.and2(logicaretard);
	FOR DUTXOR: porta_xor2 USE ENTITY WORK.xor2(logicaretard);

	BEGIN
		DUTFF2: flipflopJK PORT MAP(notalfaandQ1, notalfaandQ1, clock, Q2int);
		DUTFF1: flipflopJK PORT MAP(notalfa, notalfa, clock, Q1int);
		DUTFF0: flipflopJK PORT MAP(X, '1', clock, Q0int);
		DUTINV: porta_inversor PORT MAP(alfa, notalfa);
		DUTAND: porta_and2 PORT MAP(notalfa, Q1int, notalfaandQ1);
		DUTXOR: porta_xor2 PORT MAP(X, Q0int, alfa);
	Z2 <= Q2int; Z1 <= Q1int; Z0 <= Q0int;

END estructural;

---------- BANC DE PROVES ----------
ENTITY bdp_pr05 IS
END bdp_pr05;


ARCHITECTURE test_pr05 OF bdp_pr05 IS

	COMPONENT funcio IS
		PORT (X,clock: IN BIT; Z2,Z1,Z0: OUT BIT);
	END COMPONENT;

	SIGNAL entX, Clock, sZ2, sZ1, sZ0: BIT;
	
	FOR DUT: funcio USE ENTITY WORK.circuit_pr05(estructural);

	BEGIN
		DUT: funcio PORT MAP(entX, Clock, sZ2, sZ1, sZ0);
	
	PROCESS (entX, Clock)
		BEGIN
			entX <= NOT entX AFTER 120 ns;
			Clock <= NOT Clock AFTER 50 ns;
	END PROCESS;

    -- Simulat fins als 15000ns
END test_pr05;