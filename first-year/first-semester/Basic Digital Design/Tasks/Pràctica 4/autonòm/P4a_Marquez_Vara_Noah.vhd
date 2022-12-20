---- ENTITAT mux4a1 ----
ENTITY mux4a1 IS
	PORT(a,b,c,d,sel1,sel0: IN BIT; f: OUT BIT);
END mux4a1;

---- ARQUITECTURA LOGICARETARD ----
ARCHITECTURE logicaretard OF mux4a1 IS
	BEGIN
		f <= a AFTER 3 ns WHEN sel1 = '0' AND sel0 = '0' ELSE
		     b AFTER 3 ns WHEN sel1 = '0' AND sel0 = '1' ELSE
		     c AFTER 3 ns WHEN sel1 = '1' AND sel0 = '0' ELSE
		     d AFTER 3 ns;
END logicaretard;

---- ARQUITECTURA IFTHEN ----
ARCHITECTURE ifthen OF mux4a1 IS
BEGIN
	PROCESS (a,b,c,d,sel1,sel0)
	BEGIN
		IF sel1='0' AND sel0='0' THEN f<= a AFTER 3 ns;
		ELSIF sel1='0' AND sel0='1' THEN f<= b AFTER 3 ns;
		ELSIF sel1='1' AND sel0='0' THEN f<= c AFTER 3 ns;
		ELSIF sel1='1' AND sel0='1' THEN f<= d AFTER 3 ns;
		END IF;
	END PROCESS;
END ifthen;

---- ENTITAT FLIP-FLOP D ----
ENTITY FF_D IS
	PORT(D,clock,Pre:IN BIT; Q: OUT BIT);
END FF_D;

---- ARQUITECTURA IFTHEN ----
ARCHITECTURE ifthen OF FF_D IS
	SIGNAL qint: BIT;

	BEGIN
		PROCESS (D,clock)
		BEGIN
			IF Pre='0' THEN qint<='1' AFTER 3 ns;
			ELSIF clock'EVENT AND clock='1' THEN qint<=D AFTER 3 ns;
			END IF;
		END PROCESS;
		Q<=qint;
END ifthen;

---- ENTITAT REGISTRE ----
ENTITY registre IS
	PORT(a2,a1,a0,sel1,sel0,E,clock: IN BIT; Q2, Q1, Q0: OUT BIT);
END registre;

---- ARQUITECTURA ESTRUCTURAL ----
ARCHITECTURE estructural OF registre IS
	COMPONENT mux4a1
		PORT(a,b,c,d,sel1,sel0: IN BIT; f: OUT BIT);
	END COMPONENT;

	COMPONENT FF_D
		PORT(D,clock,Pre:IN BIT; Q: OUT BIT);
	END COMPONENT;

	SIGNAL muxa2, muxa1, muxa0, q2int, q1int, q0int:BIT;
		FOR DUT1: mux4a1 USE ENTITY WORK.mux4a1(ifthen);
		FOR DUT2: mux4a1 USE ENTITY WORK.mux4a1(ifthen);
		FOR DUT3: mux4a1 USE ENTITY WORK.mux4a1(logicaretard);
		FOR DUT4: FF_D USE ENTITY WORK.FF_D(ifthen);
		FOR DUT5: FF_D USE ENTITY WORK.FF_D(ifthen);
		FOR DUT6: FF_D USE ENTITY WORK.FF_D(ifthen);

	BEGIN
		DUT1: mux4a1 PORT MAP('1',q2int,a2,E,sel1,sel0,muxa2);
		DUT2: mux4a1 PORT MAP('1',q1int,a1,q2int,sel1,sel0,muxa1);
		DUT3: mux4a1 PORT MAP('1',q0int,a0,q1int,sel1,sel0,muxa0);
		DUT4: FF_D PORT MAP(muxa2,clock,'1',q2int);
		DUT5: FF_D PORT MAP(muxa1,clock,'1',q1int);
		DUT6: FF_D PORT MAP(muxa0,clock,'1',q0int);
	Q2<=q2int; Q1<=q1int; Q0<=q0int;
END estructural;


---- BANC DE PROVES ----
ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS
	COMPONENT registre
		PORT(a2,a1,a0,sel1,sel0,E,clock: IN BIT; Q2, Q1, Q0: OUT BIT);
	END COMPONENT;

	SIGNAL a2,a1,a0,sel1,sel0,E,clock,Q2,Q1,Q0:BIT;
		FOR DUT: registre USE ENTITY WORK.registre(estructural);
	BEGIN
		DUT: registre PORT MAP (a2,a1,a0,sel1,sel0,E,clock, Q2, Q1, Q0);

	PROCESS(a2,a1,a0,sel1,sel0,E,clock)
		BEGIN
			clock<=NOT clock AFTER 10 ns;
			sel1<=NOT sel1 AFTER 320 ns;
			sel0<=NOT sel0 AFTER 160 ns;
			E<=NOT E AFTER 640 ns;
			a2<=NOT a2 AFTER 80 ns;
			a1<=NOT a1 AFTER 40 ns;
			a0<=NOT a0 AFTER 20 ns;

	END PROCESS;
END test;

-- SIMULAT FINS ALS 1280 ns

-- El retard és sempre de 3ns
-- 1) Quan el valor de sel1 i sel0 = 00 -> Q2+,Q1+,Q0+=0
-- 2) Quan el valor de sel1 i sel0 = 01-> Q2+,Q1+,Q0+=Q2,Q1,Q0 sempre serà 0, ja que el canvi
-- de les variables és en ordre binari natural i per tant les variables de seleccio anteriors son 00 
-- (i tal i com hem dit abans Q2,Q1,Q0 son 0 quan sel=00)
-- 3) Quan sel=10 Q2+Q1+,Q0+=a2,a1,a0 com en els apartats anteriors amb 3ns de retard
-- 4) Quan sel=11 Q2+=E, Q1+=Q2+, Q0+=Q1+ (hi ha un desplaçament dels valors, entra un valor E i els altres avancen 
-- una posicio, tal i com hem dit anteriorment amb un retard de 3ns)
