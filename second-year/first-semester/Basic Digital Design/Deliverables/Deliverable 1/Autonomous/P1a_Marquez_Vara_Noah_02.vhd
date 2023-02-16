----------BANC DE PROVES----------

ENTITY bdp_portes IS
END bdp_portes;


ARCHITECTURE test OF bdp_portes IS
	COMPONENT la_porta_inversor
		PORT (a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT la_porta_and2
		PORT (a,b: IN BIT; z: OUT BIT);
	END COMPONENT;
	
	COMPONENT la_porta_and3
		PORT (a,b,c: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT la_porta_and4
		PORT (a,b,c,d: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT la_porta_or2
		PORT (a,b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT la_porta_or3
		PORT (a,b,c: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT la_porta_or4
		PORT (a,b,c,d: IN BIT; z: OUT BIT);
	END COMPONENT;

	--Definir inputs i outputs
	SIGNAL ent1, ent2, ent3, ent4, sortida_inv, sortida_and2_logica, sortida_and3_logica, sortida_and4_logica, sortida_or2_logica, sortida_or3_logica, sortida_or4_logica: BIT;
		FOR DUTINV: la_porta_inversor USE ENTITY WORK.inversor(logica);
		FOR DUTAND2: la_porta_and2 USE ENTITY WORK.and2(logica);
		FOR DUTAND3: la_porta_and3 USE ENTITY WORK.and3(logica);
		FOR DUTAND4: la_porta_and4 USE ENTITY WORK.and4(logica);
		FOR DUTOR2: la_porta_or2 USE ENTITY WORK.or2(logica);
		FOR DUTOR3: la_porta_or3 USE ENTITY WORK.or3(logica);
		FOR DUTOR4: la_porta_or4 USE ENTITY WORK.or4(logica);

	--Procediments
	BEGIN
		DUTINV: la_porta_inversor PORT MAP (ent1,sortida_inv);
		DUTAND2: la_porta_and2 PORT MAP (ent1,ent2,sortida_and2_logica);
		DUTAND3: la_porta_and3 PORT MAP (ent1,ent2,ent3,sortida_and3_logica);
		DUTAND4: la_porta_and4 PORT MAP (ent1,ent2,ent3,ent4,sortida_and4_logica);
		DUTOR2: la_porta_or2 PORT MAP (ent1,ent2,sortida_or2_logica);
		DUTOR3: la_porta_or3 PORT MAP (ent1,ent2,ent3,sortida_or3_logica);
		DUTOR4: la_porta_or4 PORT MAP (ent1,ent2,ent3,ent4,sortida_or4_logica);
			
			stimulus: PROCESS (ent1, ent2, ent3, ent4)
			BEGIN
			ent1 <= NOT ent1 AFTER 50 ns;
			ent2 <= NOT ent2 AFTER 100 ns;
			ent3 <= NOT ent3 AFTER 200 ns;
			ent4 <= NOT ent4 AFTER 400 ns;
			END PROCESS;

END test;
