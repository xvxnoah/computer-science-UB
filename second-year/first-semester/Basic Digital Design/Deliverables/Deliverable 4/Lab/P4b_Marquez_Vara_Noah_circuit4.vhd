-- Aquest circuit és l'exemple d'un comptador asíncron. Un comptador és un circuit que genera
-- una seqüència predefinida d'estats, de manera que el circuit canvia el seu estat quan rep un 
-- pols de rellotge i l'estat futur només depèn de l'estat actual.
--
-- Com és un comptador asíncron, l'entrada del sincronisme (rellotge) dels tres FFs que formen el
-- circuit no és única (cada FF canvia el seu estat en moments diferents).
--
-- Com utilitzem 3 FFs, tindrem 2^3 estats possibles, és a dir, 8 (0, 1, 2, 3, 4, 5, 6, 7).

--------  ENTITAT Mux2a1-------- 
ENTITY mux2a1 IS
	PORT(a,b,sel: IN BIT; f: OUT BIT);
END mux2a1;

ARCHITECTURE logicaretard OF mux2a1 IS
	BEGIN
		f<=((NOT sel) AND a) OR (sel AND b) AFTER 3 ns;
END logicaretard;

ARCHITECTURE estructural OF mux2a1 IS
	COMPONENT inversor IS
		PORT(a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT and2
		PORT (a,b:IN BIT; z:OUT BIT);
	END COMPONENT;

	COMPONENT or2 IS
		PORT(a,b: IN BIT; z: OUT BIT);
	END COMPONENT;

	SIGNAL inv_sel, Nsel_a, sel_b, sort_or2:BIT;
		FOR DUT1: inversor USE ENTITY WORK.inversor(logicaretard);
		FOR DUT2: and2 USE ENTITY WORK.and2(logicaretard);
		FOR DUT3: and2 USE ENTITY WORK.and2(logicaretard);
		FOR DUT4: or2 USE ENTITY WORK.or2(logicaretard);

	BEGIN
		DUT1: inversor PORT MAP(sel, inv_sel);
		DUT2: and2 PORT MAP(inv_sel,a,Nsel_a);
		DUT3: and2 PORT MAP(sel,b,sel_b);
		DUT4: or2 PORT MAP(Nsel_a, sel_b, sort_or2);
	f<=sort_or2;
END estructural;

ARCHITECTURE ifthen OF mux2a1 IS
BEGIN
	PROCESS (a,b,sel)
	BEGIN
		IF sel='0' THEN f<= a AFTER 3 ns;
		ELSIF sel='1' THEN f<= b AFTER 3 ns;
		END IF;
	END PROCESS;
END ifthen;

-------- BIESTABLE Flip-Flop T ----------
ENTITY FF_T IS
	PORT (T,clock,Clr: IN BIT; Q, NO_Q: OUT BIT);
END FF_T;

ARCHITECTURE ifthen OF FF_T IS
	SIGNAL qint: BIT;

	BEGIN
	PROCESS (T,clock,Clr)
	BEGIN
		IF Clr='0' THEN qint<='0' AFTER 3 ns;
		ELSIF clock'EVENT AND clock='1' THEN
			IF T='0' THEN qint<=qint;
			ELSIF T='1' THEN qint<= NOT qint;
			END IF;
		END IF;
	END PROCESS;
	Q<=qint AFTER 3 NS;
	NO_Q<= NOT qint AFTER 3 ns;
END ifthen;

-------- ENTITAT CIRCUIT 4 --------
ENTITY circuit4 IS
	PORT(sel,clock: IN BIT; Q0, Q1, Q2: OUT BIT);
END circuit4;

ARCHITECTURE estructural OF circuit4 IS
	COMPONENT mux2a1
		PORT(a,b,sel: IN BIT; f: OUT BIT);
	END COMPONENT;

	COMPONENT FF_T
		PORT(T,clock,Clr:IN BIT; Q, NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT nand3
		PORT (a,b,c: IN BIT; z: OUT BIT);
	END COMPONENT;

	SIGNAL mux0, mux1, mux2, q0int, nq0int, q1int, nq1int, q2int, nq2int,clear:BIT;
		FOR DUT1: mux2a1 USE ENTITY WORK.mux2a1(logicaretard);
		FOR DUT2: mux2a1 USE ENTITY WORK.mux2a1(estructural);
		FOR DUT3: mux2a1 USE ENTITY WORK.mux2a1(ifthen);
		FOR DUT4: nand3 USE ENTITY WORK.nand3(logicaretard);
		FOR DUT5: FF_T USE ENTITY WORK.FF_T(ifthen);
		FOR DUT6: FF_T USE ENTITY WORK.FF_T(ifthen);
		FOR DUT7: FF_T USE ENTITY WORK.FF_T(ifthen);


	BEGIN
		DUT1: mux2a1 PORT MAP('1','0',sel,mux0);
		DUT2: mux2a1 PORT MAP('1','0',sel,mux1);
		DUT3: mux2a1 PORT MAP('1','0',sel,mux2);
		DUT4: nand3 PORT MAP(q0int,nq1int,q2int,clear);
		DUT5: FF_T PORT MAP(mux0,clock,clear,q0int,nq0int);
		DUT6: FF_T PORT MAP(mux1,nq0int,clear,q1int,nq1int);
		DUT7: FF_T PORT MAP(mux2,nq1int,clear,q2int,nq2int);

	Q0<=q0int;  Q1<=q1int; Q2<=q2int;
END estructural;

-------- BANC DE PROVES --------
ENTITY bdp_circuit4 IS
END bdp_circuit4;

ARCHITECTURE test_circuit4 OF bdp_circuit4 IS
	COMPONENT circuit4
		PORT(sel,clock: IN BIT; Q0, Q1, Q2: OUT BIT);
	END COMPONENT;

	SIGNAL sel,clock,Q0,Q1,Q2:BIT;
		FOR DUT: circuit4 USE ENTITY WORK.circuit4(estructural);
	BEGIN
		DUT: circuit4 PORT MAP (sel,clock,Q0, Q1, Q2);

	PROCESS(sel,clock)
	BEGIN
		clock<=NOT clock AFTER 50 ns;
		sel<=NOT sel AFTER 500 ns;
	END PROCESS;
END test_circuit4;
