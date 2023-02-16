--RESPOSTA A LA PREGUNTA--
--El primer interval de temps en què ent1 = 0, ent2 = 1, ent3 = 0 i ent4 = 1, està comprès
--entre els 500ns i els 549ns.
--Les sortides són les següents:
-- sinv: 1 / sinv_retard: 0 i 1 / sand2 & sand2_retard = 0 / sand3 & sand3_retard = 0 / sand4 & sand4_retard = 0
-- sor2 & sor2_retard = 1 / sor3 & sor3_retard = 1 / sor4 & sor4_retard = 1 / sxor2 & sxor2_retard = 1
-- L'única sortida que varia degut al retard és sinv_retard, que comença a 0 i al cap de 3ns val 1.

------------BANC DE PROVES---------
ENTITY bdp_portes is
END bdp_portes;

ARCHITECTURE test OF bdp_portes IS
	COMPONENT inversor is
		PORT(a: IN BIT; b: OUT BIT);
	END COMPONENT;

	COMPONENT and2 
		PORT(a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT and3
		PORT(a, b, c: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT and4
		PORT (a,b,c,d: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT or2
		PORT(a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT or3
		PORT(a, b, c: IN BIT; z: OUT BIT);
	END COMPONENT;	

	COMPONENT or4
		PORT (a,b,c,d: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT xor2 IS
		PORT (a, b: IN BIT; z: OUT BIT);
	END COMPONENT;

	SIGNAL ent1, ent2, ent3, ent4, sinv, sinv_retard, sand2, sand2_retard, sand3, sand3_retard, sand4, sand4_retard, sor2, sor2_retard, sor3, sor3_retard, sor4, sor4_retard, sxor2, sxor2_retard: BIT;
		FOR DUTINV: inversor USE ENTITY WORK.inversor(logica);
		FOR DUTAND2: and2 USE ENTITY WORK.and2(logica);
		FOR DUTAND3: and3 USE ENTITY WORK.and3(logica);
		FOR DUTAND4: and4 USE ENTITY WORK.and4(logica);
		FOR DUTOR2: or2 USE ENTITY WORK.or2(logica);
		FOR DUTOR3: or3 USE ENTITY WORK.or3(logica);
		FOR DUTOR4: or4 USE ENTITY WORK.or4(logica);
		FOR DUTINVRET: inversor USE ENTITY WORK.inversor(logicaretard);
		FOR DUTAND2RET: and2 USE ENTITY WORK.and2(logicaretard);
		FOR DUTAND3RET: and3 USE ENTITY WORK.and3(logicaretard);
		FOR DUTAND4RET: and4 USE ENTITY WORK.and4(logicaretard);
		FOR DUTOR2RET: or2 USE ENTITY WORK.or2(logicaretard);
		FOR DUTOR3RET: or3 USE ENTITY WORK.or3(logicaretard);
		FOR DUTOR4RET: or4 USE ENTITY WORK.or4(logicaretard);	
		FOR DUTXOR2: xor2 USE ENTITY WORK.xor2(logica);
		FOR DUTXOR2RET: xor2 USE ENTITY WORK.xor2(logicaretard);

	BEGIN
		DUTINV: inversor PORT MAP (ent1, sinv);
		DUTAND2: and2 PORT MAP (ent1, ent2, sand2);
		DUTAND3: and3 PORT MAP (ent1, ent2, ent3, sand3);
		DUTAND4: and4 PORT MAP (ent1, ent2, ent3, ent4, sand4);
		DUTOR2: or2 PORT MAP (ent1, ent2, sor2);
		DUTOR3: or3 PORT MAP (ent1, ent2, ent3, sor3);
		DUTOR4: or4 PORT MAP (ent1, ent2, ent3, ent4, sor4);
		DUTINVRET: inversor PORT MAP (ent1, sinv_retard);
		DUTAND2RET: and2 PORT MAP (ent1, ent2, sand2_retard);
		DUTAND3RET: and3 PORT MAP (ent1, ent2, ent3, sand3_retard);
		DUTAND4RET: and4 PORT MAP (ent1, ent2, ent3, ent4, sand4_retard);
		DUTOR2RET: or2 PORT MAP (ent1, ent2, sor2_retard);
		DUTOR3RET: or3 PORT MAP (ent1, ent2, ent3, sor3_retard);
		DUTOR4RET: or4 PORT MAP (ent1, ent2, ent3, ent4, sor4_retard);
		DUTXOR2: xor2 PORT MAP (ent1, ent2, sxor2);
		DUTXOR2RET: xor2 PORT MAP (ent1, ent2, sxor2_retard);
		
			stimulus: PROCESS (ent1, ent2, ent3, ent4)
			BEGIN
			ent1 <= NOT ent1 AFTER 50 ns;
			ent2 <= NOT ent2 AFTER 100 ns;
			ent3 <= NOT ent3 AFTER 200 ns;
			ent4 <= NOT ent4 AFTER 400 ns;
			END PROCESS;
END test;
