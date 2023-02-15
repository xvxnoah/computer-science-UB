-- Inversor
-- Primer es declara l’entitat
ENTITY inversor IS
PORT (a : IN BIT;
f : OUT BIT);
END inversor;
-- Després es declara l’arquitectura
ARCHITECTURE logica OF inversor IS
BEGIN
f <= not a;
END logica;

ENTITY testbench IS
END testbench;
-- L’entitat banc de proves no té entrades ni sortides
ARCHITECTURE vectors OF testbench IS
-- Diem què volem testejar
COMPONENT inversor
port(
a: IN BIT;
f: OUT BIT);
END COMPONENT;
-- Definim senyals
SIGNAL a,f : BIT;
-- Diem quants i quins dispositius testeja el programa
FOR DUT: inversor USE ENTITY WORK.inversor(logica);
-- Relacionem el dispositiu i l’arquitectura
BEGIN
DUT: inversor PORT MAP (a,f);
-- Definim els terminals del dispositiu: la connexió entre els senyals que testejem
-- i els que senyals “muts” que porten les ENTITY
PROCESS
BEGIN
a <= '0';
wait for 100 ns;
a <= '1';
wait for 500 ns;
a <= '0';
wait for 1000 ns;
a <= '1';
END PROCESS;
END vectors;
