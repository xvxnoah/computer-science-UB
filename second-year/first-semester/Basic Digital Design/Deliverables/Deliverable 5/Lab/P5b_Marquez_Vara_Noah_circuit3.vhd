--ENTITAT CIRCUIT
ENTITY CIRCUIT IS
  PORT(X, Y, Ck: IN bit; z: OUT bit);
END CIRCUIT;

--ARCHITECUTRE ESTRUCTURAL OF CIRCUIT
ARCHITECTURE  estructural OF CIRCUIT IS 
  
  --components that we will need to make circuit:
  --1 flip-flop T 
  --1 flip-flop JK 
  --1 sumador 1 bit
  
  COMPONENT FF_JK_pujada IS
    PORT(J, K, CK: IN bit; Q: OUT bit);
  END COMPONENT;
  
  COMPONENT FF_T_baixada IS
    PORT(T, CK, Pre: IN bit; Q: OUT bit);
  END COMPONENT;
  
  COMPONENT sumador IS
    PORT(a, b, Cin: IN bit; Cout, S: OUT bit);
  END COMPONENT;
  
  SIGNAL Cout_int, S_int, Q1_int: bit;
  
  	FOR DUT1: FF_T_baixada USE ENTITY work.FF_T_baixada(ifthen);
  	FOR DUT2: FF_JK_pujada USE ENTITY work.FF_JK_pujada(ifthen);
  	FOR DUT3: sumador USE ENTITY work.sumador(estructural);
  
  BEGIN
    DUT1: FF_T_baixada PORT MAP(X, CK, Y, Q1_int);
    DUT2: FF_JK_pujada PORT MAP(S_int, Cout_int, CK, Z);
    DUT3: sumador PORT MAP(CK, CK, Q1_int, Cout_int, S_int);
      
END estructural;


---------------------------- BANC DE PROVES ---------------------------

--ENTITAT BANC_PROVES
ENTITY bdp_Pr05b IS
END bdp_Pr05b;

-- ARQUITECTURA TEST DE BANC_PROVES
ARCHITECTURE test_Pr05b OF bdp_Pr05b IS

  COMPONENT circuit IS
    PORT(X, Y, CK: IN bit; Z: OUT bit);
  END COMPONENT;

  -- ENTRADES:
  SIGNAL X, Y, CK: bit;
  -- SORTIDES:
  SIGNAL Z: bit;
  
  FOR DUT1: circuit USE ENTITY work.circuit(estructural);
 
  BEGIN
    DUT1: circuit PORT MAP(X, Y, CK, Z);
      
    CK <= not CK AFTER 50 ns;
    X <= '1', '0' AFTER 110 ns, '1' AFTER 155 ns, '0' AFTER 240 ns,
      '1' AFTER 310 ns, '0' AFTER 340 ns, '1' AFTER 420 ns, '0' AFTER 520 ns,
      '1' AFTER 540 ns, '0' AFTER 560 ns, '1' AFTER 590 ns, '0' AFTER 660 ns, '1' AFTER 710 ns;
    Y <= '1', '0' AFTER 60 ns, '1' AFTER 80 ns, '0' AFTER 360 ns, '1' AFTER 440 ns,
      '0' AFTER 610 ns, '1' AFTER 670 ns, '0' AFTER 740 ns, '1' AFTER 760 ns;
    
END test_Pr05b;  
