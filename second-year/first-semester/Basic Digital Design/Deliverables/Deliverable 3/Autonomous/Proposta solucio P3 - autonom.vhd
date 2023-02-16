--Biestables D
ENTITY Latch_D IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END Latch_D;

ARCHITECTURE ifthen OF Latch_D IS
SIGNAL qint: BIT;
BEGIN
PROCESS (D,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk='1' THEN
      qint <= D AFTER 2 ns;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

ENTITY FF_D IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_D;

--Arquitectura per flanc de pujada
ARCHITECTURE ifthen OF FF_D IS
SIGNAL qint: BIT;
BEGIN

PROCESS (D,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='1' THEN
      qint <= D AFTER 2 ns;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

--Arquitectura per flanc de baixada
ARCHITECTURE ifthen_b OF FF_D IS
SIGNAL qint: BIT;
BEGIN

PROCESS (D,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='0' THEN
      qint <= D AFTER 2 ns;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen_b;

--Biestables JK

ENTITY Latch_JK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END Latch_JK;

ARCHITECTURE ifthen OF Latch_JK IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr,qint)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
ELSE
IF Pre='0' THEN qint<='1' AFTER 2 ns;
ELSE
		IF Clk='1' THEN
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

--Arquitectura per flanc de baixada
ARCHITECTURE ifthen_b OF FF_JK IS
SIGNAL qint: BIT;
BEGIN
PROCESS (J,K,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
ELSE
IF Pre='0' THEN qint<='1' AFTER 2 ns;
ELSE
		IF Clk'EVENT AND Clk='0' THEN
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
END ifthen_b;


--Biestables T

ENTITY Latch_T IS
PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END Latch_T;

ARCHITECTURE ifthen OF Latch_T IS
SIGNAL qint: BIT;
BEGIN
PROCESS (T,Clk,Pre,Clr,qint)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk='1' THEN
      	IF T = '1' THEN
		qint <= NOT qint AFTER 2 ns;
		ELSE qint <= qint AFTER 2 ns;
	END IF;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

ENTITY FF_T IS
PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_T;

--Arquitectura per flanc de pujada
ARCHITECTURE ifthen OF FF_T IS
SIGNAL qint: BIT;
BEGIN
PROCESS (T,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='1' THEN
      	IF T = '1' THEN
		qint <= NOT qint AFTER 2 ns;
		ELSE qint <= qint AFTER 2 ns;
	END IF;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen;

--Arquitectura per flanc de baixada
ARCHITECTURE ifthen_b OF FF_T IS
SIGNAL qint: BIT;
BEGIN
PROCESS (T,Clk,Pre,Clr)
BEGIN
IF Clr='0' THEN qint<='0' AFTER 2 ns;
      ELSIF Pre='0' THEN qint<='1' AFTER 2 ns;
      ELSIF Clk'EVENT AND Clk='0' THEN
      	IF T = '1' THEN
		qint <= NOT qint AFTER 2 ns;
		ELSE qint <= qint AFTER 2 ns;
	END IF;
END IF;
END PROCESS;
Q<=qint; NO_Q<=NOT qint;
END ifthen_b;


--Banc de proves
ENTITY bdp_biestables IS
END bdp_biestables;

--Arquitectura del banc de proves per comprovar el funcionament dels biestables D
ARCHITECTURE test_D OF bdp_biestables IS
COMPONENT biestable_D IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

SIGNAL clock,D,preset,clear: BIT;
SIGNAL Q_LatchD, NoQ_LatchD, Q_FF_D, NoQ_FF_D: BIT;
SIGNAL Q_FF_D_b, NoQ_FF_D_b: BIT;

FOR DUT1: Biestable_D USE ENTITY WORK.Latch_D(ifthen);
FOR DUT2: Biestable_D USE ENTITY WORK.FF_D(ifthen);
FOR DUT3: Biestable_D USE ENTITY WORK.FF_D(ifthen_b);


BEGIN
DUT1: Biestable_D PORT MAP (D,clock,preset,clear,Q_LatchD, NoQ_LatchD);
DUT2: Biestable_D PORT MAP (D,clock,preset,clear,Q_FF_D, NoQ_FF_D);
DUT3: Biestable_D PORT MAP (D,clock,preset,clear,Q_FF_D_b, NoQ_FF_D_b);

PROCESS(D, clock, preset, clear)
BEGIN
D <= NOT D AFTER 125 ns;
clock <= NOT clock AFTER 50 ns;
END PROCESS;
preset <= '1';
clear <= '1';
END test_D;

--Arquitectura del banc de proves per comprovar el funcionament dels biestables JK
ARCHITECTURE test_JK OF bdp_biestables IS
COMPONENT Biestable_JK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

SIGNAL clock,J,K,preset,clear: BIT;
SIGNAL Q_LatchJK, NoQ_LatchJK, Q_FF_JK, NoQ_FF_JK: BIT;
SIGNAL Q_FF_JK_b, NoQ_FF_JK_b: BIT;

FOR DUT1: Biestable_JK USE ENTITY WORK.Latch_JK(ifthen);
FOR DUT2: Biestable_JK USE ENTITY WORK.FF_JK(ifthen);
FOR DUT3: Biestable_JK USE ENTITY WORK.FF_JK(ifthen_b);


BEGIN
DUT1: Biestable_JK PORT MAP (J,K,clock,preset,clear,Q_LatchJK, NoQ_LatchJK);
DUT2: Biestable_JK PORT MAP (J,K,clock,preset,clear,Q_FF_JK, NoQ_FF_JK);
DUT3: Biestable_JK PORT MAP (J,K,clock,preset,clear,Q_FF_JK_b, NoQ_FF_JK_b);

PROCESS(J,K, clock, preset, clear)
BEGIN
J <= NOT J AFTER 125 ns;
K <= NOT K AFTER 75 ns;
clock <= NOT clock AFTER 50 ns;
END PROCESS;
preset <= '1';
clear <= '1';
END test_JK;

--Arquitectura del banc de proves per comprovar el funcionament dels biestables T
ARCHITECTURE test_T OF bdp_biestables IS
COMPONENT biestable_T IS
PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

SIGNAL clock,T,preset,clear: BIT;
SIGNAL Q_LatchT, NoQ_LatchT, Q_FF_T, NoQ_FF_T: BIT;
SIGNAL Q_FF_Tb, NoQ_FF_Tb: BIT;

FOR DUT1: Biestable_T USE ENTITY WORK.Latch_T(ifthen);
FOR DUT2: Biestable_T USE ENTITY WORK.FF_T(ifthen);
FOR DUT3: Biestable_T USE ENTITY WORK.FF_T(ifthen_b);


BEGIN
DUT1: Biestable_T PORT MAP (T,clock,preset,clear,Q_LatchT, NoQ_LatchT);
DUT2: Biestable_T PORT MAP (T,clock,preset,clear,Q_FF_T, NoQ_FF_T);
DUT3: Biestable_T PORT MAP (T,clock,preset,clear,Q_FF_Tb, NoQ_FF_Tb);

PROCESS(T, clock, preset, clear)
BEGIN
T <= NOT T AFTER 125 ns;
clock <= NOT clock AFTER 50 ns;
END PROCESS;
preset <= '1';
clear <= '1';
END test_T;


-- Banc de Proves de tots els biestables

ARCHITECTURE test_biestables OF bdp_biestables IS
COMPONENT biestable_D IS
PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;
COMPONENT Biestable_JK IS
PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;
COMPONENT biestable_T IS
PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END COMPONENT;

SIGNAL clock,ent1,ent2,preset,clear: BIT;
SIGNAL sortQ_Latch_D, sortNOQ_Latch_D, sortQ_FF_D, sortNOQ_FF_D: BIT;
SIGNAL sortQ_Latch_JK, sortNOQ_Latch_JK, sortQ_FF_JK, sortNOQ_FF_JK: BIT;
SIGNAL sortQ_Latch_T, sortNOQ_Latch_T, sortQ_FF_T, sortNOQ_FF_T: BIT;

FOR DUT1: Biestable_D USE ENTITY WORK.Latch_D(ifthen);
FOR DUT2: Biestable_D USE ENTITY WORK.FF_D(ifthen);
FOR DUT3: Biestable_JK USE ENTITY WORK.Latch_JK(ifthen);
FOR DUT4: Biestable_JK USE ENTITY WORK.FF_JK(ifthen);
FOR DUT5: Biestable_T USE ENTITY WORK.Latch_T(ifthen);
FOR DUT6: Biestable_T USE ENTITY WORK.FF_T(ifthen);



BEGIN
DUT1: Biestable_D PORT MAP (ent1,clock,preset,clear,sortQ_Latch_D, sortNOQ_Latch_D);
DUT2: Biestable_D PORT MAP (ent1,clock,preset,clear,sortQ_FF_D, sortNOQ_FF_D);
DUT3: Biestable_JK PORT MAP (ent1,ent1,clock,preset,clear,sortQ_Latch_JK, sortNOQ_Latch_JK);
DUT4: Biestable_JK PORT MAP (ent1,ent2,clock,preset,clear,sortQ_FF_JK, sortNOQ_FF_JK);
DUT5: Biestable_T PORT MAP (ent1,clock,preset,clear,sortQ_Latch_T, sortNOQ_Latch_T);
DUT6: Biestable_T PORT MAP (ent1,clock,preset,clear,sortQ_FF_T, sortNOQ_FF_T);

PROCESS(ent1, ent2, clock, preset, clear)
BEGIN
ent1 <= NOT ent1 AFTER 800 ns;
ent2 <= NOT ent2 AFTER 400 ns;
clock <= NOT clock AFTER 50 ns;
END PROCESS;
preset <= '1';
clear <= '1';
-- simuleu fins a 15000 ns
END test_biestables;


