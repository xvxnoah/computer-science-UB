---------- PREGUNTA APARTAT 1 ----------
-- Hi ha un petit rebot perquè en temps = 200ns es produeix un canvi en els valors de 'a', 'b' i 'c', passen a valdre 0 (a i b) i 1 (c). Això
-- implica que el senyal de 'b' triga més en arribar ja que ha de passar per un inversor. Aquest minúscul temps de resposta
-- influeix en el senyal alpha i en la porta or del final, donant lloc a que en comptes d'arribar un '1' arribi un '0' a la 
-- sortida f durant 3 ns. Hem d'esperar uns 9ns (200-209ns) a que s'estabilitzi el senyal.
-- Cada 400ns podem veure repetit el mateix fenòmen (606ns, 106ns, ...).

-- COMENTARI: A l'enunciat dieu que la senyal d'A és la que ha de variar més ràpid tal i com es mostra a l'exemple. Però a l'exemple dieu que 
-- la senyal d'A ha de variar cada 200 ns, i considero que si ha de variar més ràpid hauria de ser amb els 50ns que mencioneu a la tasca. També
-- he vist que dieu que variïn les senyals cada 50ns (50, 100, 150, 200), però a l'exemple es va doblant el nombre per cada sortida 
-- (50, 100, 200, 400). 

---------- PREGUNTA APARTAT 2.d ----------
-- Hi ha més retard del que podriem esperar ja que enlloc de 3ns hi ha 6ns. Tal i com ens ha passat a la pregunta de
-- l'apartat 1, degut a que les portes estan fetes a mà i no són les predeterminades que ens ofereix el ModelSim, el
-- senyal triga un cert temps més del normal a arribar a cadascuna de les sortides (f i output wave).

---------- PREGUNTA APARTAT 2.e ----------
-- El retard en les arquitectures 'logicaretard' i 'estructural_R' s'aprecia molt més fàcilment quan ho simulem amb un
-- interval més petit de variació de la senyal (ja que els 3 i 6ns respecte a unes variacions de 5ns són molt més notables
-- que respecte a 50ns), i això pot donar lloc a ue es produeixin alguns errors en el funcionament del nostre dispositiu 
-- quan ho haguem d'implementar. Per exemple, dels 756 als 759ns, l'arquitectura 'estructural_R' es queda amb un valor de
-- '1' quan hauria d'estar a '0' durant aquell interval de temps.

---------- FUNCIÓ ----------
-- f(a,b,c,d) = a * c * (a XOR d) + (/b * c)

---------- ENTITATS I ESTRUCTURES ----------
ENTITY funcio IS
PORT(a,b,c,d: IN BIT; f: OUT BIT);
END funcio;

ARCHITECTURE logica OF funcio IS
BEGIN
f <= (a AND c AND (a XOR d)) OR ((NOT b) AND c);
END logica;

ARCHITECTURE logicaretard OF funcio IS
BEGIN
f <= (a AND c AND (a XOR d)) OR ((NOT b) AND c) AFTER 3 ns;
END logicaretard;

ARCHITECTURE estructural OF funcio IS
	COMPONENT porta_inversor IS
		PORT(a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and3
		PORT (a,b,c: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_or2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_xor2
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	SIGNAL invb, xorad, alpha, beta:BIT;

	FOR DUT1: porta_inversor USE ENTITY WORK.inversor(logica);
	FOR DUT2: porta_xor2 USE ENTITY WORK.xor2(logica);
	FOR DUT3: porta_and2 USE ENTITY WORK.and2(logica);
	FOR DUT4: porta_and3 USE ENTITY WORK.and3(logica);
	FOR DUT5: porta_or2 USE ENTITY WORK.or2(logica);

	BEGIN
		DUT1: porta_inversor PORT MAP (b,invb);
		DUT2: porta_xor2 PORT MAP (a,d,xorad);
		DUT3: porta_and2 PORT MAP (invb,c,alpha);
		DUT4: porta_and3 PORT MAP(a,c,xorad,beta);
		DUT5: porta_or2 PORT MAP (alpha,beta,f);
END estructural;


ARCHITECTURE estructural_R OF funcio IS

	COMPONENT porta_inversor IS
		PORT(a: IN BIT; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and2 IS
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_and3 IS
		PORT (a,b,c: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_or2 IS
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	COMPONENT porta_xor2 IS
		PORT(a,b: IN BIT ; z: OUT BIT);
	END COMPONENT;

	SIGNAL invb, xorad, alpha, beta:BIT;

	FOR DUT1: porta_inversor USE ENTITY WORK.inversor(logicaretard);
	FOR DUT2: porta_xor2 USE ENTITY WORK.xor2(logicaretard);
	FOR DUT3: porta_and2 USE ENTITY WORK.and2(logicaretard);
	FOR DUT4: porta_and3 USE ENTITY WORK.and3(logicaretard);
	FOR DUT5: porta_or2 USE ENTITY WORK.or2(logicaretard);

	BEGIN
		DUT1: porta_inversor PORT MAP (b,invb);
		DUT2: porta_xor2 PORT MAP (a,d,xorad);
		DUT3: porta_and2 PORT MAP (invb,c,alpha);
		DUT4: porta_and3 PORT MAP(a,c,xorad,beta);
		DUT5: porta_or2 PORT MAP (alpha,beta,f);
END estructural_R;

---------- BANC DE PROVES ----------
ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS
	COMPONENT bloc_que_simulem IS
		PORT(a,b,c,d: IN BIT ; f: OUT BIT);
	END COMPONENT;
	
	-- ent0 == senyalA, ent1 == senyalB, ent2 == senyal C
	SIGNAL ent0,ent1,ent2,ent3,sort_logica,sort_logica_R,sort_estructural,sort_estructural_R: BIT;

	FOR DUT1: bloc_que_simulem USE ENTITY WORK.funcio(logica);
	FOR DUT2: bloc_que_simulem USE ENTITY WORK.funcio(logicaretard);
	FOR DUT3: bloc_que_simulem USE ENTITY WORK.funcio(estructural);
	FOR DUT4: bloc_que_simulem USE ENTITY WORK.funcio(estructural_R);

	BEGIN
		DUT1: bloc_que_simulem PORT MAP (ent0,ent1,ent2,ent3,sort_logica);
		DUT2: bloc_que_simulem PORT MAP (ent0,ent1,ent2,ent3,sort_logica_R);
		DUT3: bloc_que_simulem PORT MAP (ent0,ent1,ent2,ent3,sort_estructural);
		DUT4: bloc_que_simulem PORT MAP (ent0,ent1,ent2,ent3,sort_estructural_R);

		PROCESS (ent0,ent1,ent2,ent3)
			BEGIN
				ent0 <= NOT ent0 AFTER 50 ns; -- Senyal A
				ent1 <= NOT ent1 AFTER 100 ns; -- Senyal B
				ent2 <= NOT ent2 AFTER 200 ns; -- Senyal C
				ent3 <= NOT ent3 AFTER 400 ns; -- Senyal D
		END PROCESS;
END test;
