-- Portes lògiques que necessitarem per fer el sumador d'1 bit:
-- xor2
-- and2
-- or2

--ENTITAT OR2
ENTITY or2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END or2;

ARCHITECTURE logica OF or2 IS
BEGIN
z<= a OR b;
END logica;

ARCHITECTURE logicaretard OF or2 IS
BEGIN
z<= a OR b AFTER 3 ns;
END logicaretard;

-- ENTITAT AND2
ENTITY and2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END and2;

ARCHITECTURE logica OF and2 IS
BEGIN
z<= a AND b;
END logica;

ARCHITECTURE logicaretard OF and2 IS
BEGIN
z<= a AND b AFTER 3 ns;
END logicaretard;

-- ENTITAT INVERSOR
ENTITY inversor IS
PORT(a: IN BIT; z: OUT BIT);
END inversor;

ARCHITECTURE logica OF inversor IS
BEGIN
z<= NOT a;
END logica;

ARCHITECTURE logicaretard OF inversor IS
BEGIN
z<= NOT a AFTER 3 ns;
END logicaretard;

-- ENTITAT XOR2
ENTITY xor2 IS
PORT(a,b: IN BIT; z: OUT BIT);
END xor2;

ARCHITECTURE logica OF xor2 IS
BEGIN
z<= a XOR b;
END logica;

ARCHITECTURE logicaretard OF xor2 IS
BEGIN
z<= a XOR b AFTER 3 ns;
END logicaretard;

------------------------FLIP-FLOPS----------------------

-- ENTITAT FF_JK_PUJADA
ENTITY FF_JK_pujada IS
  PORT(J, K, CK: IN bit; Q: OUT bit);
END FF_JK_pujada;

-- ARQUITECTURA IFTHEN DE FF_JK_PUJADA
ARCHITECTURE ifthen OF FF_JK_pujada IS
  SIGNAL qint: bit;
  BEGIN
    PROCESS(J, K, CK)
      BEGIN
        IF CK'event and CK = '1' THEN
          IF J = '0' and K = '0' THEN qint <= qint AFTER 3 ns;
          ELSIF J = '0' and K = '1' THEN qint <= '0' AFTER 3 ns;
          ELSIF J = '1' and K = '0' THEN qint <= '1' AFTER 3 ns;
          ELSE qint <= not qint AFTER 3 ns;
          END IF;
        END IF;
    END PROCESS;
  Q <= qint;
END ifthen;

-- ENTITAT FF_T_BAIXADA
ENTITY FF_T_baixada IS
  PORT(T, CK, Pre: IN bit; Q: OUT bit);
end FF_T_baixada;

-- ARQUITECTURA IFTHEN DE FF_T_BAIXADA
ARCHITECTURE ifthen OF FF_T_baixada IS
  SIGNAL qint: bit;
  BEGIN
    PROCESS(T, CK, Pre)
      BEGIN
        IF Pre = '0' THEN qint <= '1' AFTER 3 ns;
        ELSIF CK'event and CK = '0' THEN
          IF T = '0' THEN qint <= qint AFTER 3 ns;
          ELSE qint <= not qint AFTER 3 ns;
          END IF;
        END IF;
    END PROCESS;
  Q <= qint;
END ifthen;

-------------------------SUMADOR 1 BIT-------------------------
-- ENTITAT SUMADOR_1_BIT
ENTITY sumador IS
  PORT(a, b, Cin: IN bit; Cout, S: OUT bit);
END sumador;

-- ARQUITECTURA ESTRUCTURAL OF SUMADOR_1_BIT
ARCHITECTURE estructural OF sumador IS
  
  -- Component que necessitarem per fer l'arquitectura estructural del sumador d'1 bit:
  --2 and2
  --2 or2
  --2 xor2
  
  COMPONENT and2 IS
    PORT(a, b: IN bit; z: OUT bit);
  END COMPONENT;
  
  COMPONENT or2 IS
    PORT(a, b: IN bit; z:OUT bit);
  END COMPONENT;
  
  COMPONENT xor2 IS
    PORT(a, b: IN bit; z: OUT bit);
  END COMPONENT;
  
  SIGNAL sort1_and2, sort2_and2: bit;
  SIGNAL sort1_or2: bit;
  SIGNAL sort1_xor2: bit;
  
  FOR DUT1: AND2 USE ENTITY work.and2(logicaretard);
  FOR DUT2: OR2 USE ENTITY work.or2(logicaretard);
  FOR DUT3: AND2 USE ENTITY work.and2(logicaretard);
  FOR DUT4: OR2 USE ENTITY work.or2(logicaretard);
  FOR DUT5: XOR2 USE ENTITY work.xor2(logicaretard);
  FOR DUT6: XOR2 USE ENTITY work.xor2(logicaretard);
  
  BEGIN
    DUT1: AND2 PORT MAP(a, b, sort1_and2);
    DUT2: OR2 PORT MAP(a, b, sort1_or2);
    DUT3: AND2 PORT MAP(sort1_or2, Cin, sort2_and2);
    DUT4: OR2 PORT MAP(sort1_and2, sort2_and2, Cout);
    DUT5: XOR2 PORT MAP(a, b, sort1_xor2);
    DUT6: XOR2 PORT MAP(sort1_xor2, Cin, S);
      
END estructural;
