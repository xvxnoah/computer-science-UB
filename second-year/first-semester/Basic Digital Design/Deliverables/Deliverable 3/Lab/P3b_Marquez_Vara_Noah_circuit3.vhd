--------  BIESTABLE Latch D-------- 
ENTITY Latch_D IS
	PORT (D,Clk,Clr,Pre: IN BIT; Q, NO_Q: OUT BIT);
END Latch_D;

ARCHITECTURE ifthen OF Latch_D IS

	SIGNAL qint: BIT;

	BEGIN
		PROCESS (D, Clk,Clr,Pre)
		BEGIN
			IF Clr='0' THEN qint<='0' AFTER 3 ns;
			ELSIF Pre='0' THEN qint<='1' AFTER 3 ns;
			ELSIF Clk='1' THEN qint<=D AFTER 3 ns;
			END IF;
		END PROCESS;
	Q<=qint;
	NO_Q<= NOT qint;
END ifthen;

-------- BIESTABLE Flip-Flop J-K ----------
ENTITY FF_JK IS
	PORT (J,K,Clk,Clr,Pre: IN BIT; Q, NO_Q: OUT BIT);
END FF_JK;

ARCHITECTURE ifthen OF FF_JK IS

	SIGNAL qint: BIT;

	BEGIN
		PROCESS (J,K,Clk,Clr,Pre)
		BEGIN
			IF Clr='0' THEN qint<='0' AFTER 3 ns;
			ELSIF Pre='0' THEN qint<='1' AFTER 3 ns;
			ELSIF Clk'EVENT AND Clk='1' THEN
				IF J='0' AND K='0' THEN qint<=qint AFTER 3 ns;
				ELSIF J='0' AND K='1' THEN qint<='0' AFTER 3 ns;
				ELSIF J='1' AND K='0' THEN qint<='1' AFTER 3 ns;
				ELSIF J='1' AND K='1' THEN qint<=NOT qint AFTER 3 ns;
				END IF;
			END IF;
		END PROCESS;
	Q<=qint;
	NO_Q<= NOT qint;
END ifthen;

-------- Circuit3 --------
ENTITY circuit3 IS
	PORT(x,ck:IN BIT; Q1,notQ1,J,K,Z: OUT BIT);
END circuit3;

ARCHITECTURE estructural OF circuit3 IS

	COMPONENT inversor
		PORT (a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT and2
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT or2
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT Latch_D
		PORT (D,Clk,Clr,Pre: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT FF_JK
		PORT (J,K,Clk,Clr,Pre: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	SIGNAL invx,Q1int,notQ1int,sand2,sor2,notQ2int:BIT;

		FOR DUT1: inversor USE ENTITY WORK.inversor(logicaretard);
		FOR DUT2: and2 USE ENTITY WORK.and2(logicaretard);
		FOR DUT3: or2 USE ENTITY WORK.or2(logicaretard);
		FOR DUT4: Latch_D USE ENTITY WORK.Latch_D(ifthen);
		FOR DUT5: FF_JK USE ENTITY WORK.FF_JK(ifthen);

		BEGIN
			DUT1: inversor PORT MAP(x,invx);
			DUT2: and2 PORT MAP(x,Q1int,sand2);
			DUT3: or2 PORT MAP (invx,notQ1int,sor2);
			DUT4: Latch_D PORT MAP(x,ck,'1','1',Q1int,notQ1int);
			DUT5: FF_JK PORT MAP (sand2,sor2,ck,'1','1',Z,notQ2int);

		Q1<= Q1int; 
		notQ1<= notQ1int;
		J<= sand2;
		K<=sor2;
END estructural;


ENTITY bdp_circuit3 IS
END bdp_circuit3;

ARCHITECTURE test_circuit3 OF bdp_circuit3 IS

	COMPONENT circuit3
		PORT(x,ck:IN BIT; Q1,notQ1,J,K,Z: OUT BIT);
	END COMPONENT;

	SIGNAL x,ck,Q1,notQ1,J,K,Z: BIT;

		FOR DUT: circuit3 USE ENTITY WORK.circuit3(estructural);

		BEGIN
			DUT: circuit3 PORT MAP(x,ck, Q1,notQ1,J,K,Z);

	PROCESS(ck)
		BEGIN
			ck<=NOT ck AFTER 50 ns;
	END PROCESS;

	PROCESS
		BEGIN
			x<='0';
			WAIT FOR 75 ns;
			x<='1';
			WAIT FOR 85 ns;
			x<='0';
			WAIT FOR 55 ns;
			x<='1';
			WAIT FOR 10 ns;
			x<='0';
			WAIT FOR 20 ns;
			x<='1';
			WAIT FOR 10 ns;
			x<='0';
			WAIT FOR 20 ns;
			x<='1';
			WAIT FOR 10 ns;
			x<='0';
			WAIT FOR 40 ns;
			x<='1';
			WAIT FOR 35 ns;
			x<='0';
	END PROCESS;
END test_circuit3;
