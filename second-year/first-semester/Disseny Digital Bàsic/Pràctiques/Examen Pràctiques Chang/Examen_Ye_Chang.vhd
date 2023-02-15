-------------------------------APARTAT 1-------------------------------

--entity FF_JK
entity FF_JK is
  port(
    J, K, clock, preset: in bit;
    Q, NQ: out bit);
end FF_JK;

--architecture ifthen of FF_JK
architecture ifthen of FF_JK is
  signal qint: bit;
  begin
    process(J, K, clock, preset)
      begin
	if preset = '0' then qint <= '1' after 5 ns;
        --negative edge-triggering
        elsif clock'event and clock = '0' then
          if J = '0' and K = '0' then qint <= qint after 5 ns;
          elsif J = '0' and K = '1' then qint <= '0' after 5 ns;
          elsif J = '1' and K = '0' then qint <= '1' after 5 ns;
          else qint <= not qint after 5 ns;
          end if;
        end if;
    end process;
  Q <= qint;
  NQ <= not qint;
end ifthen;


------------------------------APARTAT 2--------------------------------

--entity bloc1
entity bloc1 is
  port(
    a1, a0: in bit;
    f2, f1, f0: out bit);
end bloc1;

--entity logica_retard of bloc 1
architecture logica_retard of bloc1 is
  begin
    f2 <= (not a0) and a1 after 5 ns;
    f1 <= a1 or a0 after 5 ns;
    f0 <= not a0 after 5 ns;
end logica_retard;


------------------------------APARTAT 3---------------------------------

--portes lògiques que necessitariem per crear l'estructural del bloc2

--entity and2
entity and2 is
  port(
    a, b: in bit;
    z: out bit);
end and2;

--architecture logica_retard of and2
architecture logica_retard of and2 is
  begin
    z <= a and b after 5 ns;
end logica_retard;

--entity inversor
entity inversor is
  port(
    a: in bit;
    z: out bit);
end inversor;

--architecture logica_retard of inversor
architecture logica_retard of inversor is
  begin
    z <= not a after 5 ns;
end logica_retard;

--------------------BLOC2------------------

--entity bloc2
entity bloc2 is
  port(
    a1, a0: in bit;
    f3, f2, f1, f0: out bit);
end bloc2;

--architecture estructural of bloc2
architecture estructural of bloc2 is

  --components per crear l'estructural de bloc2
  --and2 i inversor
  component and2 is
    port(
      a, b: in bit;
      z: out bit);
  end component;

  component inversor is
    port(
      a: in bit;
      z: out bit);
  end component;

  --defining internal signals
  signal inva1, inva0: bit;

  for dut1: and2 use entity work.and2(logica_retard);
  for dut2: and2 use entity work.and2(logica_retard);
  for dut3: and2 use entity work.and2(logica_retard);
  for dut4: and2 use entity work.and2(logica_retard);
  for dut5: inversor use entity work.inversor(logica_retard);
  for dut6: inversor use entity work.inversor(logica_retard);

  --let's assign the internal signals
  begin
    
    dut1: and2 port map(a1, a0, f3);
    dut2: and2 port map(a1, inva0, f2);
    dut3: and2 port map(inva1, a0, f1);
    dut4: and2 port map(inva1, inva0, f0);
    dut5: inversor port map(a1, inva1);
    dut6: inversor port map(a0, inva0);

end estructural;
    
------------------------------APARTAT 4---------------------------------

--entity circuit
entity circuit is
  port(
    x1, x0, clock: in bit;
    z3, z2, z1, z0: out bit);
end circuit;

--architecture estructural of circuit
architecture estructural of circuit is

  --components que necessitem per crear l'estructural del circuit:
  --flip-flop jk, bloc1 i bloc2

  component FF_JK is
    port(
      J, K, clock, preset: in bit;
      Q, NQ: out bit);
  end component;

  component bloc1 is
    port(
      a1, a0: in bit;
      f2, f1, f0: out bit);
  end component;

  component bloc2 is
    port(
      a1, a0: in bit;
      f3, f2, f1, f0: out bit);
  end component;

  --defining internal signals
  
  signal f2_int, f1_int, f0_int, Q1_int, Q0_int, NQ1_int, NQ0_int: bit;

  for dut1: bloc1 use entity work.bloc1(logica_retard);
  for dut2: FF_JK use entity work.FF_JK(ifthen);
  for dut3: FF_JK use entity work.FF_JK(ifthen);
  for dut4: bloc2 use entity work.bloc2(estructural);

  --let's assign the internal signals
  begin
    
    dut1: bloc1 port map(Q0_int, x1, f2_int, f1_int, f0_int);
    dut2: FF_JK port map(f2_int, f1_int, clock, x0, Q1_int, NQ1_int);
    dut3: FF_JK port map(f0_int, '1', clock, x0, Q0_int, NQ0_int);
    dut4: bloc2 port map(Q1_int, Q0_int, z3, z2, z1, z0);

end estructural;

--------------------------------------APARTAT 5----------------------------------

--entity bdp
entity bdp is
end bdp;

--architecture test of bdp 
architecture test of bdp is

  --components a testejar
  component circuit is
    port(
      x1, x0, clock: in bit;
      z3, z2, z1, z0: out bit);
  end component;

  --defining signals of input and output
  --input
  signal x1, x0, clock: bit;
  --output
  signal z3, z2, z1, z0: bit;
  
  for dut1: circuit use entity work.circuit(estructural);

  --let's begin with the test  
  begin
  
    dut1: circuit port map(x1, x0, clock, z3, z2, z1, z0);

    clock <= not clock after 50 ns;
    x1 <= '0', '1' after 650 ns, '0' after 1300 ns;
    x0 <= '1', '0' after 1150 ns, '1' after 1650 ns;

end test;

--------------------------------------APARTAT 6----------------------------------

--aquest circuit es un tipus de comptador, el que fa es compta els nombres
--1, 2, 4, 8 i quan arriba al 8, per tant tenim quatre estats, A, B, C i D.

--els estats son:
--A -> sortida 0001 (1 en decimal)
--B -> sortida 0010 (2 en decimal)
--C -> sortida 0100 (4 en decimal)
--D -> sortida 1000 (8 en decimal)

--quan la entrada val 00, anem a l'estat A
--quan la entrada val 01, anel a l'estat B
--quan la entrada val 10, anem a l'estat C
--quan la entrada val 11, anem a l'estat D

--cal apreciar que el comptador només compta quan  x0 = 1 i x1 = 0, si x0 = 1 i x1 = 1
--el comptador reseteja els valors i s'apaga, tornarà a començar quan x1 = 0 i x0 = 1 ja que
--el circuit es asincrona ( preset).

--a l'inici del cronograma es pot apreciar com en l'instant 0, x0 val 0 durant un instant
--i per tant els FF_JK donen de sortida 1 ja que preset = 0 (sortida ff = 1) per això hi ha
--un rebot ja que el programa calcula mal els resultats deguda al retras de les portes.

--el circuit comença a treballar en l'instant 100 ns (les sortides trigan una mica més deguda al retras)
--que es quan clock fa el primer franc de baixada,
--i a més a més, es pot veure com les sortides del FF_JK canvien d'1 a 0 ja que x0 = 1 en aquest instant.
--com que la entrada del bloc2 = 00, estem a l'estat A que ens dona de sortida 0001.

--a la segona franc de baixada (200 ns), bloc2 reb d'entrada 01 i podem veure que canvia d'estat A a l'estat B

--al tercer franc de baixada (300 ns) , bloc2 reb d'entrada 10 i podem veure que canvia d'estat B a l'estat C

--en tots els moments on x1= 0 i x0 = 1 el comptador funciona, i per tant, dona les sortides de cada estat.

 
