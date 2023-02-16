---------- PREGUNTA APARTAT D ----------
-- A més del retard acumulat de 9ns en l'arquitectura estructural_R també hi ha rebots causats pel retard intern de les funcions
-- que la composen (ja que les portes estan fetes a mà i no són les predeterminades que ens ofereix el ModelSim). El període
--d'estabilització del senyal desprès d'un canvi en la funció dura entre 6-9ns (per exemple entre 450 i 456ns). La senyal triga un cert temps més del
--normal en arribar a cadascuna de les sortides. Podem apreciar els certs rebots de la sortida estructuralR en els instants de temps:
-- 506-512ns / 556-562ns / 656-659ns / 706-709ns / 756-759ns ...

---------- PREGUNTA APARTAT E ----------
-- Si fixem el temps de variació de les senyals cada 5 ns, el temps de retard de les arquitectures 'logicaretard' i 'estructural_R'
-- serà superior al que dura un valor a la senyal (ja que la senyal varia cada 5ns) i per tant la funció no dona el resultat esperat
-- ja que el retard és massa significatiu.

---------- FUNCIÓ ----------
-- f(a,b,c,d) = (/a * b * /c + b * /d + a * c * d + a * /d) XOR (a + /d)

---------- ENTITATS I ESTRUCTURES ----------
ENTITY funcio_2 IS
PORT(a,b,c,d: IN BIT; f: OUT BIT);
END funcio_2;

ARCHITECTURE logica OF funcio_2 IS
BEGIN
f<= ((NOT a AND b AND NOT c) OR (b AND NOT d) 
     OR (a AND c AND d) or (a AND NOT d)) XOR (a OR NOT d);
END logica;

ARCHITECTURE logicaretard OF funcio_2 IS
BEGIN
f<= ((NOT a AND b AND NOT c) OR (b AND NOT d) 
     OR (a AND c AND d) OR (a AND NOT d)) XOR (a OR NOT d) AFTER 3 ns;
END logicaretard;

ARCHITECTURE estructural OF funcio_2 IS
	COMPONENT inversor IS
		PORT(a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT and2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT and3
		PORT(a,b,c: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT or2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT or4
		PORT(a,b,c,d: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT xor2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	SIGNAL inva, invc, invd, inva_b_invc, b_invd, a_c_d, a_invd, sort_or4, sort_or2, sort_xor2:BIT;

	FOR DUT1: inversor USE ENTITY WORK.inversor(logica);
	FOR DUT2: inversor USE ENTITY WORK.inversor(logica);
	FOR DUT3: inversor USE ENTITY WORK.inversor(logica);
	FOR DUT4: and3 USE ENTITY WORK.and3(logica);
	FOR DUT5: and2 USE ENTITY WORK.and2(logica);
	FOR DUT6: and3 USE ENTITY WORK.and3(logica);
	FOR DUT7: and2 USE ENTITY WORK.and2(logica);
	FOR DUT8: or4 USE ENTITY WORK.or4(logica);
	FOR DUT9: or2 USE ENTITY WORK.or2(logica);
	FOR DUT10: xor2 USE ENTITY WORK.xor2(logica);

	BEGIN
		DUT1: inversor PORT MAP (a,inva);
		DUT2: inversor PORT MAP (c,invc);
		DUT3: inversor PORT MAP (d,invd);
		DUT4: and3 PORT MAP (inva,b,invc,inva_b_invc);
		DUT5: and2 PORT MAP (b,invd,b_invd);
		DUT6: and3 PORT MAP (a,c,d,a_c_d);
		DUT7: and2 PORT MAP (a,invd,a_invd);
		DUT8: or4 PORT MAP (inva_b_invc,b_invd,a_c_d,a_invd,sort_or4);
		DUT9: or2 PORT MAP (a,invd,sort_or2);
		DUT10: xor2 PORT MAP (sort_or4,sort_or2,f);
END estructural;


ARCHITECTURE estructural_R OF funcio_2 IS

	COMPONENT inversor IS
		PORT(a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT and2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT and3
		PORT(a,b,c: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT or2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT or4
		PORT(a,b,c,d: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT xor2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	SIGNAL inva, invc, invd, inva_b_invc, b_invd, a_c_d, a_invd, sort_or4, sort_or2, sort_xor2:BIT;

	FOR DUT1: inversor USE ENTITY WORK.inversor(logicaretard);
	FOR DUT2: inversor USE ENTITY WORK.inversor(logicaretard);
	FOR DUT3: inversor USE ENTITY WORK.inversor(logicaretard);
	FOR DUT4: and3 USE ENTITY WORK.and3(logicaretard);
	FOR DUT5: and2 USE ENTITY WORK.and2(logicaretard);
	FOR DUT6: and3 USE ENTITY WORK.and3(logicaretard);
	FOR DUT7: and2 USE ENTITY WORK.and2(logicaretard);
	FOR DUT8: or4 USE ENTITY WORK.or4(logicaretard);
	FOR DUT9: or2 USE ENTITY WORK.or2(logicaretard);
	FOR DUT10: xor2 USE ENTITY WORK.xor2(logicaretard);

	BEGIN
		DUT1: inversor PORT MAP (a,inva);
		DUT2: inversor PORT MAP (c,invc);
		DUT3: inversor PORT MAP (d,invd);
		DUT4: and3 PORT MAP (inva,b,invc,inva_b_invc);
		DUT5: and2 PORT MAP (b,invd,b_invd);
		DUT6: and3 PORT MAP (a,c,d,a_c_d);
		DUT7: and2 PORT MAP (a,invd,a_invd);
		DUT8: or4 PORT MAP (inva_b_invc,b_invd,a_c_d,a_invd,sort_or4);
		DUT9: or2 PORT MAP (a,invd,sort_or2);
		DUT10: xor2 PORT MAP (sort_or4,sort_or2,f);
END estructural_R;

---------- BANC DE PROVES ----------
ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS
	COMPONENT funcio_2
		PORT(a,b,c,d: IN BIT ; f: OUT BIT);
	END COMPONENT;

	SIGNAL ent0, ent1, ent2, ent3, sort_logica, sort_logica_R, sort_estructural, sort_estructural_R: BIT;

	FOR DUT1: funcio_2 USE ENTITY WORK.funcio_2(logica);
	FOR DUT2: funcio_2 USE ENTITY WORK.funcio_2(logicaretard);
	FOR DUT3: funcio_2 USE ENTITY WORK.funcio_2(estructural);
	FOR DUT4: funcio_2 USE ENTITY WORK.funcio_2(estructural_R);

	BEGIN
		DUT1: funcio_2 PORT MAP (ent0,ent1,ent2,ent3,sort_logica);
		DUT2: funcio_2 PORT MAP (ent0,ent1,ent2,ent3,sort_logica_R);
		DUT3: funcio_2 PORT MAP (ent0,ent1,ent2,ent3,sort_estructural);
		DUT4: funcio_2 PORT MAP (ent0,ent1,ent2,ent3,sort_estructural_R);

		PROCESS (ent0,ent1,ent2,ent3)
			BEGIN
				ent0 <= NOT ent0 AFTER 50 ns;
				ent1 <= NOT ent1 AFTER 100 ns;
				ent2 <= NOT ent2 AFTER 200 ns;
				ent3 <= NOT ent3 AFTER 400 ns;
		END PROCESS;
END test;
