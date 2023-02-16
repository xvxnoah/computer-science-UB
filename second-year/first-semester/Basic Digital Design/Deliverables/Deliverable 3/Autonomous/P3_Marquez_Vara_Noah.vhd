-------- PREGUNTES -------- 
-- 3. Hi ha un cert comportament extrany a tots els biestables entre els 200 i 400 ns. Podem veure com
--    en aquest moment és en el què les entrades 'Preset' i 'Clear' tenen totes dues valor '0', i això
--    no és realista ja que Q i /Q donarien 0 alhora, pero al wave tots els biestables es situen a '0'
--    com si tinguessim 'Preset = 1' i 'Clear = 0'.
--    Podriem dir que això succeeix perquè tots els biestables estan constuïts mitjançant la lògica
--    'ifthen' i no amb portes lògiques com veniem fent (and, nand, or...). És per això que interpreta
--    que si 'Clear' és igual a 0, la sortida ha de donar 0 passi el que passi, sense tenir en compte
--    l'entrada del 'Preset'.

-- 4. Un Latch s'activa sempre i quan el clock (o la senyal que li assignem) sigui '1', mentre
--    que el Flip-Flop s'activa només en els moments que clock canvia de '0' a '1' o de '1' a '0',
--    sent en el primer cas activat per un flanc de pujada i en el segon per un flanc de baixada.
--    Afectarà a tots dos les variables asincròniques ('Clear' i 'Preset').  


--------  BIESTABLES Latch D i Flip-Flop D -------- 
ENTITY Latch_D IS
	PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END Latch_D;

ARCHITECTURE ifthen OF Latch_D IS
	
	SIGNAL qint: BIT;
	
	BEGIN
		PROCESS (D,Clk,Pre,Clr)
		BEGIN
			IF Clr = '0' THEN qint <= '0' AFTER 2 ns;
			ELSIF Pre = '0' THEN qint <= '1' AFTER 2 ns;
			ELSIF Clk = '1' THEN qint <=D AFTER 2 ns;
			END IF;
		END PROCESS;
		
	Q <= qint;
	NO_Q <= NOT qint;

END ifthen;

ENTITY FF_D IS
	PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_D;


ARCHITECTURE ifthen OF FF_D IS
	
	SIGNAL qint: BIT;
	
	BEGIN
		PROCESS (D,Clk,Pre,Clr)
		BEGIN
			IF Clr = '0' THEN qint <= '0' AFTER 2 ns;
			ELSIF Pre = '0' THEN qint <= '1' AFTER 2 ns;
			ELSIF Clk'EVENT AND Clk = '1' THEN qint <= D AFTER 2 ns;
			END IF;
		END PROCESS;
		
	Q <= qint;
	NO_Q <= NOT qint;

END ifthen;

-------- BIESTABLES Latch J-K i Flip-Flop J-K ----------
ENTITY Latch_JK IS
	PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END Latch_JK;


ARCHITECTURE ifthen OF Latch_JK IS

	SIGNAL qint: BIT;
	BEGIN
		PROCESS (J,K,Clk,Pre,Clr)
		BEGIN
			IF Clr = '0' THEN qint <= '0' AFTER 2 ns;
			ELSIF Pre = '0' THEN qint <= '1' AFTER 2 ns;
			ELSIF Clk = '1' THEN
				IF J = '0' AND K='0' THEN qint <= qint AFTER 2 ns;
				ELSIF J = '0' AND K = '1' THEN qint <= '0' AFTER 2 ns;
				ELSIF J = '1' AND K = '0' THEN qint <= '1' AFTER 2 ns;
				ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 2 ns;
				END IF;
			END IF;
		END PROCESS;
	
	Q <= qint;
	NO_Q <= NOT qint;

END ifthen;

ENTITY FF_JK IS
	PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_JK;


ARCHITECTURE ifthen OF FF_JK IS

	SIGNAL qint: BIT;
	BEGIN
		PROCESS (J,K,Clk,Pre,Clr)
		BEGIN
			IF Clr = '0' THEN qint <= '0' AFTER 2 ns;
			ELSIF Pre = '0' THEN qint <= '1' AFTER 2 ns;
			ELSIF Clk'EVENT AND Clk = '1' THEN
				IF J = '0' AND K='0' THEN qint <= qint AFTER 2 ns;
				ELSIF J = '0' AND K = '1' THEN qint <= '0' AFTER 2 ns;
				ELSIF J = '1' AND K = '0' THEN qint <= '1' AFTER 2 ns;
				ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 2 ns;
				END IF;
			END IF;
		END PROCESS;
	
	Q <= qint;
	NO_Q <= NOT qint;

END ifthen;

-------- BIESTABLES Latch T i Flip-Flop T --------
ENTITY Latch_T IS
	PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END Latch_T;


ARCHITECTURE ifthen OF Latch_T IS

	SIGNAL qint: BIT;
	BEGIN
		PROCESS (T,Clk,Pre,Clr)
		BEGIN
			IF Clr = '0' THEN qint <= '0' AFTER 2 ns;
			ELSIF Pre = '0' THEN qint <= '1' AFTER 2 ns;
			ELSIF Clk = '1' THEN
				IF T = '0' THEN qint <= qint AFTER 2 ns;
				ELSIF T = '1' THEN qint <= NOT qint AFTER 2 ns;
				END IF;
			END IF;
		END PROCESS;
	
	Q <= qint;
	NO_Q <= NOT qint;

END ifthen;

ENTITY FF_T IS
	PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
END FF_T;


ARCHITECTURE ifthen OF FF_T IS

	SIGNAL qint: BIT;
	BEGIN
		PROCESS (T,Clk,Pre,Clr)
		BEGIN
			IF Clr = '0' THEN qint <= '0' AFTER 2 ns;
			ELSIF Pre = '0' THEN qint <= '1' AFTER 2 ns;
			ELSIF Clk'EVENT AND Clk = '1' THEN
				IF T = '0' THEN qint <= qint AFTER 2 ns;
				ELSIF T = '1' THEN qint <= NOT qint AFTER 2 ns;
				END IF;
			END IF;
		END PROCESS;
	
	Q <= qint;
	NO_Q <= NOT qint;

END ifthen;

-------- BANC DE PROVES --------
ENTITY bdp_biestables IS
END bdp_biestables;

ARCHITECTURE test_biestables OF bdp_biestables IS

	COMPONENT mi_Latch_D IS
		PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT mi_FF_D IS
		PORT(D,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT mi_Latch_JK IS
		PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT mi_FF_JK IS
		PORT(J,K,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT mi_Latch_T IS
		PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	COMPONENT mi_FF_T IS
		PORT(T,Clk,Pre,Clr: IN BIT; Q,NO_Q: OUT BIT);
	END COMPONENT;

	SIGNAL ent1, ent2: BIT;
	SIGNAL clock, preset, clear: BIT;
	SIGNAL sLatchD, sLatchDno, sFFD, sFFDno, sLatchJK, sLatchJKno, sFFJK, sFFJKno, sLatchT, sLatchTno, sFFT, sFFTno: BIT;

	FOR DUTLD: mi_Latch_D USE ENTITY WORK.Latch_D(ifthen);
	FOR DUTFFD: mi_FF_D USE ENTITY WORK.FF_D(ifthen);
	FOR DUTLJK: mi_Latch_JK USE ENTITY WORK.Latch_JK(ifthen);
	FOR DUTFFJK: mi_FF_JK USE ENTITY WORK.FF_JK(ifthen);
	FOR DUTLT: mi_Latch_T USE ENTITY WORK.Latch_T(ifthen);
	FOR DUTFFT: mi_FF_T USE ENTITY WORK.FF_T(ifthen);

	BEGIN
		DUTLD: mi_Latch_D PORT MAP (ent1,clock,preset,clear,sLatchD,sLatchDno);
		DUTFFD: mi_FF_D PORT MAP (ent1,clock,preset,clear,sFFD,sFFDno);
		DUTLJK: mi_Latch_JK PORT MAP (ent1,ent2,clock,preset,clear,sLatchJK,sLatchJKno);
		DUTFFJK: mi_FF_JK PORT MAP (ent1,ent2,clock,preset,clear,sFFJK,sFFJKno);
		DUTLT: mi_Latch_T PORT MAP (ent1,clock,preset,clear,sLatchT,sLatchTno);
		DUTFFT: mi_FF_T PORT MAP (ent1,clock,preset,clear,sFFT,sFFTno);
		
		ent1 <= NOT ent1 AFTER 800 ns;
		ent2 <= NOT ent2 AFTER 400 ns;
		clock <= NOT clock AFTER 500 ns;
		preset <= '0','1' AFTER 600 ns;
		clear <= '1','0' AFTER 200 ns, '1' AFTER 400 ns;

		-- He simulat amb 15000 ns però amb menys temps també es podia apreciar el correcte funcionament.

END test_biestables;
