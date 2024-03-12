DROP TABLE Bandy CASCADE CONSTRAINTS;
DROP TABLE Kocury CASCADE CONSTRAINTS;
DROP TABLE Wrogowie_kocurow CASCADE CONSTRAINTS;
DROP TABLE Wrogowie;
DROP TABLE Funkcje;

ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

CREATE TABLE Bandy
(   nr_bandy NUMBER(2) CONSTRAINT bd_nr_pk PRIMARY KEY,
    nazwa VARCHAR2(20) CONSTRAINT bd_nazwa_nn NOT NULL,
    teren VARCHAR2(15) CONSTRAINT bd_teren_unq UNIQUE,
    szef_bandy VARCHAR2(15) CONSTRAINT bd_szef_unq UNIQUE);

CREATE TABLE Funkcje
(   funkcja VARCHAR2(10) CONSTRAINT fun_f_pk PRIMARY KEY,
    min_myszy NUMBER(3) CONSTRAINT fun_min_m CHECK(min_myszy>5),
    max_myszy NUMBER(3) CONSTRAINT fun_max_m_lt CHECK(max_myszy<200),
    CONSTRAINT fum_max_gt_min CHECK(max_myszy>=min_myszy));

CREATE TABLE Wrogowie
(   imie_wroga VARCHAR2(15) CONSTRAINT wr_imie_pk PRIMARY KEY,
    stopien_wrogosci NUMBER(2) CONSTRAINT wr_stw_gt CHECK(stopien_wrogosci BETWEEN 1 AND 10),
    gatunek VARCHAR2(15),
    lapowka VARChAR2(20));

CREATE TABLE Kocury
(   imie VARCHAR2(15) CONSTRAINT k_imie_nn NOT NULL,
    plec VARCHAR2(1) CONSTRAINT k_plec_ch CHECK(plec IN ('M','D')),
    pseudo VARCHAR2(15) CONSTRAINT k_pseudo_pk PRIMARY KEY,
    funkcja VARCHAR2(10) CONSTRAINT k_fun_fk REFERENCES Funkcje(funkcja),
    szef VARCHAR2(15) CONSTRAINT k_szef_fk REFERENCES Kocury(pseudo),
    w_stadku_od DATE DEFAULT SYSDATE,
    przydzial_myszy NUMBER(3),
    myszy_extra NUMBER(3),
    nr_bandy NUMBER(2) CONSTRAINT k_nrb_fk REFERENCES Bandy(nr_bandy));

CREATE TABLE Wrogowie_kocurow
(   pseudo VARCHAR2(15) CONSTRAINT wrk_pseudo_fk REFERENCES Kocury(pseudo),
    imie_wroga VARCHAR2(15) CONSTRAINT wrk_im_wr_fk REFERENCES Wrogowie(imie_wroga),
    data_incydentu DATE CONSTRAINT wrk_di_nn NOT NULL,
    opis_incydentu VARCHAR2(50),
    CONSTRAINT wrk_pk PRIMARY KEY (pseudo, imie_wroga));

INSERT ALL
INTO Funkcje VALUES ('SZEFUNIO',90,110)
INTO Funkcje VALUES ('BANDZIOR',70,90)
INTO Funkcje VALUES ('LOWCZY',60,70)
INTO Funkcje VALUES ('LAPACZ',50,60)
INTO Funkcje VALUES ('KOT',40,50)
INTO Funkcje VALUES ('MILUSIA',20,30)
INTO Funkcje VALUES ('DZIELCZY',45,55)
INTO Funkcje VALUES ('HONOROWA',6,25)
SELECT * FROM dual;

INSERT ALL
INTO Wrogowie VALUES ('KAZIO',10,'CZLOWIEK','FLASZKA')
INTO Wrogowie VALUES ('GLUPIA ZOSKA',1,'CZLOWIEK','KORALIK')
INTO Wrogowie VALUES ('SWAWOLNY DYZIO',7,'CZLOWIEK','GUMA DO ZUCIA')
INTO Wrogowie VALUES ('BUREK',4,'PIES','KOSC')
INTO Wrogowie VALUES ('DZIKI BILL',10,'PIES',NULL)
INTO Wrogowie VALUES ('REKSIO',2,'PIES','KOSC')
INTO Wrogowie VALUES ('BETHOVEN',1,'PIES','PEDIGRIPALL')
INTO Wrogowie VALUES ('CHYTRUSEK',5,'LIS','KURCZAK')
INTO Wrogowie VALUES ('SMUKLA',1,'SOSNA',NULL)
INTO Wrogowie VALUES ('BAZYLI',3,'KOGUT','KURA DO STADA')
SELECT * FROM dual;

INSERT ALL
INTO Bandy VALUES (1,'SZEFOSTWO','CALOSC','TYGRYS')
INTO Bandy VALUES (2,'CZARNI RYCERZE','POLE','LYSY')
INTO Bandy VALUES (3,'BIALI LOWCY','SAD','ZOMBI')
INTO Bandy VALUES (4,'LACIACI MYSLIWI','GORKA','RAFA')
INTO Bandy VALUES (5,'ROCKERSI','ZAGRODA',NULL)
SELECT * FROM dual;

ALTER TABLE Kocury 
DISABLE CONSTRAINT k_szef_fk;

INSERT ALL
INTO Kocury VALUES ('MRUCZEK','M','TYGRYS','SZEFUNIO',NULL,'2002-01-01',103,33,1)
INTO Kocury VALUES ('CHYTRY','M','BOLEK','DZIELCZY','TYGRYS','2002-05-05',50,NULL,1)
INTO Kocury VALUES ('KOREK','M','ZOMBI','BANDZIOR','TYGRYS','2004-03-16',75,13,3)
INTO Kocury VALUES ('BOLEK','M','LYSY','BANDZIOR','TYGRYS','2006-08-15',72,21,2)
INTO Kocury VALUES ('ZUZIA','D','SZYBKA','LOWCZY','LYSY','2006-07-21',65,NULL,2)
INTO Kocury VALUES ('RUDA','D','MALA','MILUSIA','TYGRYS','2006-09-17',22,42,1)
INTO Kocury VALUES ('PUCEK','M','RAFA','LOWCZY','TYGRYS','2006-10-15',65,NULL,4)
INTO Kocury VALUES ('PUNIA','D','KURKA','LOWCZY','ZOMBI','2008-01-01',61,NULL,3)
INTO Kocury VALUES ('BELA','D','LASKA','MILUSIA','LYSY','2008-02-01',24,28,2)
INTO Kocury VALUES ('KSAWERY','M','MAN','LAPACZ','RAFA','2008-07-12',51,NULL,4)
INTO Kocury VALUES ('MELA','D','DAMA','LAPACZ','RAFA','2008-11-01',51,NULL,4)
INTO Kocury VALUES ('JACEK','M','PLACEK','LOWCZY','LYSY','2008-12-01',67,NULL,2)
INTO Kocury VALUES ('BARI','M','RURA','LAPACZ','LYSY','2009-09-01',56,NULL,2)
INTO Kocury VALUES ('MICKA','D','LOLA','MILUSIA','TYGRYS','2009-10-14',25,47,1)
INTO Kocury VALUES ('LUCEK','M','ZERO','KOT','KURKA','2010-03-01',43,NULL,3)
INTO Kocury VALUES ('SONIA','D','PUSZYSTA','MILUSIA','ZOMBI','2010-11-18',20,35,3)
INTO Kocury VALUES ('LATKA','D','UCHO','KOT','RAFA','2011-01-01',40,NULL,4)
INTO Kocury VALUES ('DUDEK','M','MALY','KOT','RAFA','2011-05-15',40,NULL,4)
SELECT * FROM dual;

ALTER TABLE Kocury 
ENABLE CONSTRAINT k_szef_fk;

ALTER TABLE Bandy 
ADD CONSTRAINT bd_szef_fk
FOREIGN KEY (szef_bandy)
REFERENCES Kocury(pseudo);

INSERT ALL
INTO Wrogowie_Kocurow VALUES ('TYGRYS','KAZIO','2004-10-13','USILOWAL NABIC NA WIDLY')
INTO Wrogowie_Kocurow VALUES ('ZOMBI','SWAWOLNY DYZIO','2005-03-07','WYBIL OKO Z PROCY')
INTO Wrogowie_Kocurow VALUES ('BOLEK','KAZIO','2005-03-29','POSZCZUL BURKIEM')
INTO Wrogowie_Kocurow VALUES ('SZYBKA','GLUPIA ZOSKA','2006-09-12','UZYLA KOTA JAKO SCIERKI')
INTO Wrogowie_Kocurow VALUES ('MALA','CHYTRUSEK','2007-03-07','ZALECAL SIE')
INTO Wrogowie_Kocurow VALUES ('TYGRYS','DZIKI BILL','2007-06-12','USILOWAL POZBAWIC ZYCIA')
INTO Wrogowie_Kocurow VALUES ('BOLEK','DZIKI BILL','2007-11-10','ODGRYZL UCHO')
INTO Wrogowie_Kocurow VALUES ('LASKA','DZIKI BILL','2008-12-12','POGRYZL ZE LEDWO SIE WYLIZALA')
INTO Wrogowie_Kocurow VALUES ('LASKA','KAZIO','2009-01-07','ZLAPAL ZA OGON I ZROBIL WIATRAK')
INTO Wrogowie_Kocurow VALUES ('DAMA','KAZIO','2009-02-07','CHCIAL OBEDRZEC ZE SKORY')
INTO Wrogowie_Kocurow VALUES ('MAN','REKSIO','2009-04-14','WYJATKOWO NIEGRZECZNIE OBSZCZEKAL')
INTO Wrogowie_Kocurow VALUES ('LYSY','BETHOVEN','2009-05-11','NIE PODZIELIL SIE SWOJA KASZA')
INTO Wrogowie_Kocurow VALUES ('RURA','DZIKI BILL','2009-09-03','ODGRYZL OGON')
INTO Wrogowie_Kocurow VALUES ('PLACEK','BAZYLI','2010-07-12','DZIOBIAC UNIEMOZLIWIL PODEBRANIE KURCZAKA')
INTO Wrogowie_Kocurow VALUES ('PUSZYSTA','SMUKLA','2010-11-19','OBRZUCILA SZYSZKAMI')
INTO Wrogowie_Kocurow VALUES ('KURKA','BUREK','2010-12-14','POGONIL')
INTO Wrogowie_Kocurow VALUES ('MALY','CHYTRUSEK','2011-07-13','PODEBRAL PODEBRANE JAJKA')
INTO Wrogowie_Kocurow VALUES ('UCHO','SWAWOLNY DYZIO','2011-07-14','OBRZUCIL KAMIENIAMI')
SELECT * FROM dual;

COMMIT;

-- 1
SELECT imie_wroga "WROG", opis_incydentu "PRZEWINA"
FROM Wrogowie_Kocurow
WHERE data_incydentu >= '2009-01-01' AND data_incydentu <= '2009-12-31';

-- 2
SELECT imie "IMIE", funkcja "FUNKCJA", w_stadku_od "Z NAMI OD"
FROM Kocury
WHERE w_stadku_od >= '2005-09-01' AND w_stadku_od <= '2007-07-31' AND plec = 'D';

-- 3
SELECT imie_wroga "WROG", gatunek, stopien_wrogosci
FROM Wrogowie
WHERE lapowka IS NULL
ORDER BY stopien_wrogosci ASC;

-- 4
SELECT imie || ' zwany ' || pseudo || ' (fun. ' || funkcja || ') lowi myszki w bandzie ' || nr_bandy || ' od ' || w_stadku_od "WSZYSTKO O KOCURACH"
FROM Kocury
WHERE plec = 'M';

-- 5
SELECT pseudo, REGEXP_REPLACE(REGEXP_REPLACE(pseudo, 'A', '#', 1, 1), 'L', '%', 1, 1) "Po wymianie A na # oraz L na %"
FROM Kocury
WHERE pseudo LIKE '%L%A%' OR pseudo LIKE '%A%L%';

-- 6
SELECT imie, w_stadku_od "W stadku", ROUND(przydzial_myszy / 1.1, 0) "Zjadal", TO_CHAR(ADD_MONTHS(w_stadku_od, 6), 'YYYY-MM-DD') "Podwyzka", przydzial_myszy "Zjada"
FROM Kocury
WHERE EXTRACT(MONTH FROM w_stadku_od) >= '03' AND EXTRACT(MONTH FROM w_stadku_od) <= '09' AND w_stadku_od <= ADD_MONTHS(SYSDATE, -12*14);

-- 7
SELECT imie, przydzial_myszy * 3 "MYSZY KWARTALNE", NVL(myszy_extra, 0) * 3 "KWARTALNE DODATKI"
FROM Kocury
WHERE przydzial_myszy > NVL(myszy_extra, 0) * 2 AND przydzial_myszy >= 55;

-- 8
SELECT imie, 
    DECODE(SIGN((12 * (NVL(przydzial_myszy,0) + NVL(myszy_extra, 0))) - 660),
          -1, 'Ponizej 660',
          0, 'Limit',
          12 * (NVL(przydzial_myszy,0) + NVL(myszy_extra, 0))) "Zjada rocznie"
FROM Kocury;

--9
SELECT pseudo, w_stadku_od "W stadku",
    DECODE(EXTRACT (MONTH FROM TO_DATE('2023-10-24', 'YYYY-MM-DD')) - EXTRACT (MONTH FROM NEXT_DAY(TO_DATE('2023-10-24', 'YYYY-MM-DD'), 3)),
        0, DECODE(SIGN(EXTRACT (DAY FROM w_stadku_od) - 16),
            -1, TO_CHAR(NEXT_DAY('2023-10-24', 3), 'YYYY-MM-DD'),
            TO_CHAR(NEXT_DAY(LAST_DAY(ADD_MONTHS('2023-10-24', 1)) - 7, 3), 'YYYY-MM-DD')),
        TO_CHAR(NEXT_DAY(LAST_DAY(ADD_MONTHS('2023-10-24', 1)) - 7, 3), 'YYYY-MM-DD')
        ) "Wyplata"
FROM kocury;

SELECT pseudo, w_stadku_od "W stadku",
    DECODE(EXTRACT (MONTH FROM TO_DATE('2023-10-26', 'YYYY-MM-DD')) - EXTRACT (MONTH FROM NEXT_DAY(TO_DATE('2023-10-26', 'YYYY-MM-DD'), 3)),
        0, DECODE(SIGN(EXTRACT (DAY FROM w_stadku_od) - 16),
            -1, TO_CHAR(NEXT_DAY('2023-10-26', 3), 'YYYY-MM-DD'),
            TO_CHAR(NEXT_DAY(LAST_DAY(ADD_MONTHS('2023-10-26', 1)) - 7, 3), 'YYYY-MM-DD')),
        TO_CHAR(NEXT_DAY(LAST_DAY(ADD_MONTHS('2023-10-26', 1)) - 7, 3), 'YYYY-MM-DD')
        ) "Wyplata"
FROM kocury;

--10
--10.1
SELECT pseudo || ' - ' || 
    DECODE(SIGN(COUNT(pseudo) - 1),
        0, 'Unikalny',
        'nieunikalny') "Unikalnosc atr. PSEUDO"
FROM Kocury
GROUP BY pseudo;

--10.2
SELECT szef || ' - ' || 
    DECODE(SIGN(COUNT(szef) - 1),
        0, 'Unikalny',
        'nieunikalny') "Unikalnosc atr. SZEF"
FROM Kocury
WHERE szef IS NOT NULL
GROUP BY szef;

--11
SELECT pseudo "Pseudonim", COUNT(pseudo) "Liczba wrogow"
FROM Wrogowie_kocurow
GROUP BY pseudo
HAVING COUNT(pseudo) >= 2;

--12
SELECT 'Liczba kotow =' " ", COUNT(funkcja) " ", 'lowi jako' " ", funkcja " ", 'i zjada max.' " ", TO_CHAR(MAX(NVL(przydzial_myszy, 0)) + MAX(NVL(myszy_extra, 0)), '00.00') " ", 'myszy miesiecznie' " "
FROM Kocury
WHERE funkcja != 'SZEFUNIO' AND plec = 'D'
GROUP BY funkcja
HAVING AVG(NVL(przydzial_myszy, 0)) + AVG(NVL(myszy_extra, 0)) > 50;
    
--13
SELECT nr_bandy "Nr bandy", plec "Plec", MIN(NVL(przydzial_myszy,0)) "Minimalny przydzial"
FROM Kocury
GROUP BY nr_bandy, plec;

--14
SELECT level "Poziom", pseudo "Pseudonim", funkcja "Funkcja", nr_bandy "Nr bandy"
FROM Kocury
WHERE plec = 'M'
CONNECT BY PRIOR pseudo=szef
START WITH funkcja = 'BANDZIOR';

--15
SELECT RPAD('===>', (level - 1) * 4, '===>') || TO_CHAR(level - 1) || '                ' || imie "Hierarchia", NVL(szef, 'Sam sobie panem') "Pseudo szefa", funkcja "Funkcja"
FROM Kocury
WHERE myszy_extra IS NOT NULL
CONNECT BY PRIOR pseudo=szef
START WITH szef IS NULL;

--16
SELECT LPAD(' ', 4*(LEVEL-1)) || pseudo "Droga sluzbowa"  
FROM Kocury
CONNECT BY PRIOR szef = pseudo AND pseudo != 'RAFA'
START WITH plec='M' 
    AND ADD_MONTHS(TO_DATE('2023-06-29', 'YYYY-MM-DD'), -14*12) > w_stadku_od
    AND myszy_extra IS NULL
    AND pseudo != 'RAFA';

--17
SELECT pseudo "Poluje w polu", przydzial_myszy " Przydzial myszy", B.nazwa "Nr bandy"
FROM Kocury K JOIN Bandy B
    ON K.nr_bandy = B.nr_bandy
WHERE przydzial_myszy > 50 AND teren IN ('POLE','CALOSC');

--18
SELECT K1.imie, K1.w_stadku_od "Poluje od"
FROM Kocury K1, Kocury K2
WHERE K2.imie='JACEK' AND K1.w_stadku_od < K2.w_stadku_od
ORDER BY K1.w_stadku_od DESC;

--19 a
SELECT K1.imie "Imie", ' | ' " ", K1.funkcja "Funkcja",  ' | ' " ", K2.imie "Szef 1", NVL(K3.imie, ' ') " Szef 2", NVL(K4.imie, ' ') "Szef 3"
FROM Kocury K1
     JOIN Kocury K2 ON K1.szef = K2.pseudo
     LEFT JOIN Kocury K3 ON K2.szef = K3.pseudo
     LEFT JOIN Kocury K4 ON K3.szef = K4.pseudo
WHERE K1.funkcja IN ('KOT', 'MILUSIA');


SELECT *
FROM (SELECT CONNECT_BY_ROOT imie "Imie", imie szef, CONNECT_BY_ROOT funkcja "Funkcja", LEVEL "LVL"
      FROM KOCURY
      CONNECT BY PRIOR szef = pseudo
      START WITH funkcja IN ('KOT','MILUSIA'))
PIVOT (
    szef
    FOR LVL
    IN (2 "Szef 1", 3 "Szef 2", 4 "Szef 3")
    );

--19 c
SELECT CONNECT_BY_ROOT imie "Imie",
       CONNECT_BY_ROOT funkcja "Funkcja",
       REPLACE(SYS_CONNECT_BY_PATH(imie, ' | '), ' | ' || CONNECT_BY_ROOT IMIE || ' ' , '') "Imiona kolejnych szefow"
FROM Kocury
WHERE szef IS NULL
CONNECT BY PRIOR szef = pseudo
START WITH funkcja IN ('KOT','MILUSIA');

--20
SELECT K.imie "Imie kotki", B.nazwa "Nazwa bandy", WK.imie_wroga, W.stopien_wrogosci, WK.data_incydentu "Data inc."
FROM Kocury K
     JOIN Bandy B ON K.nr_bandy = B.nr_bandy
     JOIN Wrogowie_kocurow WK ON K.pseudo = WK.pseudo
     JOIN Wrogowie W ON WK.imie_wroga = W.imie_wroga
WHERE K.plec='D' AND WK.data_incydentu > TO_DATE('2007-01-01');

--21
SELECT B.nazwa "Nazwa bandy", COUNT(DISTINCT K.pseudo) "Koty z wrogami"
FROM Kocury K
     JOIN Bandy B ON K.nr_bandy=B.nr_bandy
     JOIN Wrogowie_kocurow WK ON WK.pseudo=K.pseudo
GROUP BY B.nazwa;

--22 
SELECT K.funkcja "Funkcja", K.pseudo "Pseudonim", COUNT(DISTINCT WK.imie_wroga) "Liczba wrogow"
FROM Kocury K 
     JOIN Wrogowie_kocurow WK ON K.pseudo=WK.pseudo
GROUP BY K.funkcja, K.pseudo
HAVING COUNT(*) > 1;

--23
SELECT imie, (NVL(przydzial_myszy, 0) + myszy_extra) * 12 "Dawka roczna", 'powyzej 864' "Dawka"
FROM Kocury
WHERE myszy_extra IS NOT NULL AND (NVL(przydzial_myszy, 0) + myszy_extra) * 12 > 864
UNION
SELECT imie, (NVL(przydzial_myszy, 0) + myszy_extra) * 12 "Dawka roczna", '864' "Dawka"
FROM Kocury
WHERE myszy_extra IS NOT NULL AND (NVL(przydzial_myszy, 0) + myszy_extra) * 12 = 864
UNION
SELECT imie, (NVL(przydzial_myszy, 0) + myszy_extra) * 12 "Dawka roczna", 'ponizej 864' "Dawka"
FROM Kocury
WHERE myszy_extra IS NOT NULL AND (NVL(przydzial_myszy, 0) + myszy_extra) * 12 < 864
ORDER BY 2 DESC;

--24 a
SELECT B.nr_bandy "Nr bandy", B.nazwa, B.teren
FROM Bandy B LEFT JOIN Kocury K ON B.nr_bandy = K.nr_bandy
WHERE K.nr_bandy IS NULL;

--24 b
SELECT nr_bandy "Nr bandy", nazwa, teren
FROM Bandy
MINUS
SELECT DISTINCT B.nr_bandy "Nr bandy", B.nazwa, B.teren
FROM Bandy B JOIN Kocury K ON B.nr_bandy = K.nr_bandy;

--25
SELECT imie, funkcja, przydzial_myszy
FROM Kocury
WHERE przydzial_myszy >= ALL (
    SELECT 3 * (K.przydzial_myszy)
    FROM Kocury K
    JOIN Bandy B ON K.nr_bandy = B.nr_bandy
    WHERE K.funkcja = 'MILUSIA' AND B.teren IN ('SAD', 'CALOSC')
);

--26
SELECT K2.funkcja, K2.AVG
FROM
  (SELECT MIN(AVG) "MINAVG", MAX(AVG) "MAXAVG"
  FROM (
    SELECT funkcja, CEIL(AVG(przydzial_myszy + NVL(myszy_extra, 0))) "AVG"
    FROM Kocury
    WHERE funkcja != 'SZEFUNIO'
    GROUP BY funkcja
  )) K1

  JOIN

  (SELECT funkcja, CEIL(AVG(przydzial_myszy + NVL(myszy_extra, 0))) "AVG"
  FROM Kocury
  WHERE funkcja != 'SZEFUNIO'
  GROUP BY funkcja) K2

  ON K1.MINAVG = K2.AVG
     OR K1.MAXAVG = K2.AVG
ORDER BY K2.AVG;

--27a
SELECT pseudo, przydzial_myszy + NVL(myszy_extra, 0) "ZJADA"
FROM Kocury K
WHERE (SELECT COUNT(DISTINCT przydzial_myszy + NVL(myszy_extra, 0)) FROM Kocury
      WHERE przydzial_myszy + NVL(myszy_extra, 0) > K.przydzial_myszy + NVL(K.myszy_extra, 0)) < 1
ORDER BY 2 DESC;

--27b
SELECT pseudo, NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA"
FROM Kocury
WHERE przydzial_myszy + NVL(myszy_extra, 0) IN (
  SELECT *
  FROM (
    SELECT DISTINCT przydzial_myszy + NVL(myszy_extra, 0)
    FROM Kocury
    ORDER BY 1 DESC
  ) WHERE ROWNUM <= 12
);

--27c
SELECT K1.pseudo, AVG(NVL(K1.przydzial_myszy, 0) + NVL(K1.myszy_extra, 0)) "ZJADA"
FROM Kocury K1 JOIN Kocury K2
    ON K1.przydzial_myszy + NVL(K1.myszy_extra, 0) <= NVL(K2.przydzial_myszy, 0) + NVL(K2.myszy_extra, 0)
GROUP BY K1.pseudo
HAVING COUNT(DISTINCT NVL(K2.przydzial_myszy, 0) + NVL(K2.myszy_extra, 0)) <= 1
ORDER BY 2 DESC;

--27d
SELECT  pseudo, ZJADA
FROM
(
  SELECT  pseudo,
    NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA",
    DENSE_RANK() OVER (
      ORDER BY przydzial_myszy + NVL(myszy_extra, 0) DESC
    ) RANK
  FROM Kocury
)
WHERE RANK <= 6;

--28
SELECT TO_CHAR(YEAR), SUM
FROM
(
  SELECT YEAR, SUM, ABS(SUM-AVG) "DIFF"
  FROM
    (
      SELECT EXTRACT(YEAR FROM w_stadku_od) "YEAR", COUNT(EXTRACT(YEAR FROM w_stadku_od)) "SUM"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) JOIN (
      SELECT AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od))) "AVG"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) ON SUM < AVG
)
WHERE DIFF < ALL
(
  SELECT MAX(ABS(SUM-AVG)) "DIFF"
  FROM
    (
      SELECT EXTRACT(YEAR FROM w_stadku_od) "YEAR", COUNT(EXTRACT(YEAR FROM w_stadku_od)) "SUM"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) JOIN (
      SELECT AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od))) "AVG"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) ON SUM < AVG
)

UNION ALL

SELECT 'Srednia', ROUND(AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od))), 7) "AVG"
FROM Kocury
GROUP BY EXTRACT(YEAR FROM w_stadku_od)

UNION ALL

SELECT TO_CHAR(YEAR), SUM
FROM
(
  SELECT YEAR, SUM, ABS(SUM-AVG) "DIFF"
  FROM
    (
      SELECT EXTRACT(YEAR FROM w_stadku_od) "YEAR", COUNT(EXTRACT(YEAR FROM w_stadku_od)) "SUM"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) JOIN (
      SELECT AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od))) "AVG"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) ON SUM > AVG
)
WHERE DIFF < ALL
(
  SELECT MAX(ABS(SUM-AVG)) "DIFF"
  FROM
    (
      SELECT EXTRACT(YEAR FROM w_stadku_od) "YEAR", COUNT(EXTRACT(YEAR FROM w_stadku_od)) "SUM"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) JOIN  (
      SELECT AVG(COUNT(EXTRACT(YEAR FROM w_stadku_od))) "AVG"
      FROM Kocury
      GROUP BY EXTRACT(YEAR FROM w_stadku_od)
    ) ON SUM > AVG
);

--29a
SELECT K1.imie, MIN(NVL(przydzial_myszy, 0) + NVL(K1.myszy_extra, 0)) "ZJADA", K1.nr_bandy, TO_CHAR(AVG(K2.przydzial_myszy + NVL(K2.myszy_extra, 0)), '00.00') "SREDNIA BANDY"
FROM Kocury K1 JOIN Kocury K2 ON K1.nr_bandy = K2.nr_bandy
WHERE K1.PLEC = 'M'
GROUP BY K1.imie, K1.nr_bandy
HAVING MIN(K1.przydzial_myszy + NVL(K1.myszy_extra, 0)) < AVG(K2.przydzial_myszy + NVL(K2.myszy_extra, 0));

--29b
SELECT imie, NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA", K1.nr_bandy, TO_CHAR(AVG, '00.00') "SREDNIA BANDY"
FROM Kocury K1 JOIN (SELECT nr_bandy, AVG(przydzial_myszy + NVL(myszy_extra, 0)) "AVG" FROM Kocury GROUP BY nr_bandy) K2
    ON K1.nr_bandy= K2.nr_bandy
       AND przydzial_myszy + NVL(myszy_extra, 0) < AVG
WHERE PLEC = 'M';

--29c
SELECT imie, NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0) "ZJADA", nr_bandy,
  TO_CHAR((SELECT AVG(przydzial_myszy + NVL(myszy_extra, 0)) "AVG" FROM Kocury K WHERE Kocury.nr_bandy = K.nr_bandy), '00.00') "SREDNIA BANDY"
FROM Kocury
WHERE PLEC = 'M'
      AND przydzial_myszy + NVL(myszy_extra, 0) < (SELECT AVG(przydzial_myszy + NVL(myszy_extra, 0)) "AVG" FROM Kocury K WHERE Kocury.nr_bandy= K.nr_bandy);
      
--30
SELECT imie, TO_CHAR(w_stadku_od, 'YYYY-MM-DD') || ' <--- NAJSTARSZY STAZEM W BANDZIE ' || nazwa "WSTAPIL DO STADKA"
FROM (
  SELECT imie, w_stadku_od, nazwa, MIN(w_stadku_od) OVER (PARTITION BY Kocury.nr_bandy) minstaz
  FROM Kocury JOIN Bandy ON Kocury.nr_bandy= Bandy.nr_bandy
)
WHERE w_stadku_od = minstaz

UNION ALL

SELECT imie, TO_CHAR(w_stadku_od, 'YYYY-MM-DD') || ' <--- NAJMLODSZY STAZEM W BANDZIE ' || nazwa "WSTAPIL DO STADKA"
FROM (
  SELECT imie, w_stadku_od, nazwa, MAX(w_stadku_od) OVER (PARTITION BY Kocury.nr_bandy) maxstaz
  FROM Kocury JOIN Bandy ON Kocury.nr_bandy = Bandy.nr_bandy
)
WHERE w_stadku_od = maxstaz

UNION ALL

SELECT imie, TO_CHAR(w_stadku_od, 'YYYY-MM-DD')
FROM (
  SELECT imie, w_stadku_od, nazwa,
    MIN(w_stadku_od) OVER (PARTITION BY Kocury.nr_bandy) minstaz,
    MAX(w_stadku_od) OVER (PARTITION BY Kocury.nr_bandy) maxstaz
  FROM Kocury JOIN Bandy ON Kocury.nr_bandy= Bandy.nr_bandy
)
WHERE W_STADKU_OD != minstaz AND
      W_STADKU_OD != maxstaz
ORDER BY IMIE;

--31
CREATE OR REPLACE VIEW Podsumowanie(nazwa_bandy, sre_spoz, max_spoz, min_spoz, koty, koty_z_dod)
AS
SELECT nazwa, AVG(przydzial_myszy), MAX(przydzial_myszy), MIN(przydzial_myszy), COUNT(pseudo), COUNT(myszy_extra)
FROM Kocury JOIN Bandy ON Kocury.nr_bandy= Bandy.nr_bandy
GROUP BY nazwa;

SELECT *
FROM Podsumowanie;

SELECT pseudo "PSEUDONIM", imie, funkcja, przydzial_myszy "ZJADA", 'OD ' || min_spoz || ' DO ' || max_spoz "GRANICE SPOZYCIA", TO_CHAR(w_stadku_od, 'YYYY-MM-DD') "LOWI OD"
FROM (
    Kocury 
    JOIN Bandy ON Kocury.nr_bandy= Bandy.nr_bandy 
    JOIN Podsumowanie ON Bandy.nazwa = Podsumowanie.nazwa_bandy
)
WHERE pseudo = 'PLACEK';

--32
CREATE OR REPLACE VIEW NajdluzszeStaze(pseudo, plec, przydzial_myszy, myszy_extra, nr_bandy)
AS
SELECT pseudo, plec, przydzial_myszy, myszy_extra, nr_bandy
FROM Kocury
WHERE pseudo IN
(
  SELECT pseudo
  FROM Kocury JOIN Bandy ON Kocury.nr_bandy = Bandy.nr_bandy
  WHERE nazwa = 'CZARNI RYCERZE'
  ORDER BY w_stadku_od
  FETCH NEXT 3 ROWS ONLY
)
OR pseudo IN
(
  SELECT pseudo
  FROM Kocury JOIN Bandy ON Kocury.nr_bandy= Bandy.nr_bandy
  WHERE nazwa = 'LACIACI MYSLIWI'
  ORDER BY w_stadku_od
  FETCH NEXT 3 ROWS ONLY
);

SELECT pseudo, plec, przydzial_myszy "Myszy przed podw.", NVL(myszy_extra, 0) "Ekstra przed podw."
FROM NajdluzszeStaze;

UPDATE NajdluzszeStaze
SET przydzial_myszy = przydzial_myszy + DECODE(plec, 
                                            'D', 0.1 * (SELECT MIN(przydzial_myszy) FROM Kocury), 
                                            10),
    myszy_extra = NVL(myszy_extra, 0) + 0.15 * (SELECT AVG(NVl(myszy_extra, 0)) 
                                                FROM Kocury 
                                                WHERE NajdluzszeStaze.nr_bandy = nr_bandy);
SELECT pseudo, plec, przydzial_myszy "Myszy po podw.", NVL(myszy_extra, 0) "Ekstra po podw."
FROM NajdluzszeStaze;

ROLLBACK;

--33a
SELECT TO_CHAR(DECODE(plec, 'D', NAZWA_BANDY, ' ')) "NAZWA BANDY",
       TO_CHAR(DECODE(plec, 'D', 'Kotka', 'Kocor')) "PLEC",
       TO_CHAR(COUNT(*)) "ILE",
       TO_CHAR(SUM(SZEFUNIO)) "SZEFUNIO",
       TO_CHAR(SUM(BANDZIOR)) "BANDZIOR",
       TO_CHAR(SUM(LOWCZY)) "LOWCZY",
       TO_CHAR(SUM(LAPACZ)) "LAPACZ",
       TO_CHAR(SUM(KOT)) "KOT",
       TO_CHAR(SUM(MILUSIA)) "MILUSIA",
       TO_CHAR(SUM(DZIELCZY)) "DZIELCZY",
       TO_CHAR(SUM(SZEFUNIO) + SUM(BANDZIOR) + SUM(LOWCZY) + SUM(LAPACZ) + SUM(KOT) + SUM(MILUSIA) + SUM(DZIELCZY)) "SUMA"
FROM (
    SELECT B.nazwa "NAZWA_BANDY",
        plec "PLEC",
        TO_CHAR(DECODE(K.funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "SZEFUNIO",
        TO_CHAR(DECODE(K.funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "BANDZIOR",
        TO_CHAR(DECODE(K.funkcja, 'LOWCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "LOWCZY",
        TO_CHAR(DECODE(K.funkcja, 'LAPACZ', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "LAPACZ",
        TO_CHAR(DECODE(K.funkcja, 'KOT', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "KOT",
        TO_CHAR(DECODE(K.funkcja, 'MILUSIA', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "MILUSIA",
        TO_CHAR(DECODE(K.funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "DZIELCZY"
    FROM Bandy B
         JOIN Kocury K ON B.nr_bandy = K.nr_bandy
)
GROUP BY NAZWA_BANDY, PLEC

UNION ALL

SELECT 'Z--------------', '------', '--------', '---------', '---------', '--------', '--------', '--------', '--------', '--------', '--------' FROM DUAL 

UNION ALL

SELECT 'ZJADA RAZEM',
        ' ',
        ' ',
       TO_CHAR(SUM(SZEFUNIO)) "SZEFUNIO",
       TO_CHAR(SUM(BANDZIOR)) "BANDZIOR",
       TO_CHAR(SUM(LOWCZY)) "LOWCZY",
       TO_CHAR(SUM(LAPACZ)) "LAPACZ",
       TO_CHAR(SUM(KOT)) "KOT",
       TO_CHAR(SUM(MILUSIA)) "MILUSIA",
       TO_CHAR(SUM(DZIELCZY)) "DZIELCZY",
       TO_CHAR(SUM(SZEFUNIO) + SUM(BANDZIOR) + SUM(LOWCZY) + SUM(LAPACZ) + SUM(KOT) + SUM(MILUSIA) + SUM(DZIELCZY)) "SUMA"
FROM (
    SELECT TO_CHAR(DECODE(funkcja, 'SZEFUNIO', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "SZEFUNIO",
        TO_CHAR(DECODE(funkcja, 'BANDZIOR', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "BANDZIOR",
        TO_CHAR(DECODE(funkcja, 'LOWCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "LOWCZY",
        TO_CHAR(DECODE(funkcja, 'LAPACZ', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "LAPACZ",
        TO_CHAR(DECODE(funkcja, 'KOT', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "KOT",
        TO_CHAR(DECODE(funkcja, 'MILUSIA', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "MILUSIA",
        TO_CHAR(DECODE(funkcja, 'DZIELCZY', NVL(przydzial_myszy, 0) + NVL(myszy_extra, 0), 0)) "DZIELCZY"
    FROM Kocury
)
ORDER BY 1,2;

--33b
SELECT *
FROM
(
  SELECT TO_CHAR(DECODE(plec, 'D', nazwa, ' ')) "NAZWA BANDY",
    TO_CHAR(DECODE(plec, 'D', 'Kotka', 'Kocor')) "Plec",
    TO_CHAR(ile) "ILE",
    TO_CHAR(NVL(szefunio, 0)) "SZEFUNIO",
    TO_CHAR(NVL(bandzior,0)) "BANDZIOR",
    TO_CHAR(NVL(lowczy,0)) "LOWCZY",
    TO_CHAR(NVL(lapacz,0)) "LAPACZ",
    TO_CHAR(NVL(kot,0)) "KOT",
    TO_CHAR(NVL(milusia,0)) "MILUSIA",
    TO_CHAR(NVL(dzielczy,0)) "DZIELCZY",
    TO_CHAR(NVL(suma,0)) "SUMA"
  FROM
  (
    SELECT nazwa, plec, funkcja, przydzial_myszy + NVL(myszy_extra, 0) liczba
    FROM Kocury K 
         JOIN Bandy B ON K.nr_bandy = B.nr_bandy
  ) PIVOT (
      SUM(liczba) FOR funkcja IN (
      'SZEFUNIO' szefunio, 'BANDZIOR' bandzior, 'LOWCZY' lowczy, 'LAPACZ' lapacz,
      'KOT' kot, 'MILUSIA' milusia, 'DZIELCZY' dzielczy
    )
  ) JOIN (
    SELECT nazwa "N", plec "P", COUNT(pseudo) ile, SUM(przydzial_myszy + NVL(myszy_extra, 0)) suma
    FROM Kocury K 
         JOIN Bandy B ON K.nr_bandy= B.nr_bandy
    GROUP BY nazwa, plec
    ORDER BY nazwa
  ) ON N = nazwa AND P = plec
)


UNION ALL

SELECT 'Z--------------', '------', '--------', '---------', '---------', '--------', '--------', '--------', '--------', '--------', '--------' FROM DUAL

UNION ALL

SELECT  'ZJADA RAZEM',
        ' ',
        ' ',
        TO_CHAR(NVL(szefunio, 0)) szefunio,
        TO_CHAR(NVL(bandzior, 0)) bandzior,
        TO_CHAR(NVL(lowczy, 0)) lowczy,
        TO_CHAR(NVL(lapacz, 0)) lapacz,
        TO_CHAR(NVL(kot, 0)) kot,
        TO_CHAR(NVL(milusia, 0)) milusia,
        TO_CHAR(NVL(dzielczy, 0)) dzielczy,
        TO_CHAR(NVL(suma, 0)) suma
FROM
(
  SELECT funkcja, przydzial_myszy + NVL(myszy_extra, 0) liczba
  FROM Kocury K 
       JOIN Bandy B ON K.nr_bandy = B.nr_bandy
) PIVOT (
    SUM(liczba) FOR funkcja IN (
    'SZEFUNIO' szefunio, 'BANDZIOR' bandzior, 'LOWCZY' lowczy, 'LAPACZ' lapacz,
    'KOT' kot, 'MILUSIA' milusia, 'DZIELCZY' dzielczy
  )
) CROSS JOIN (
  SELECT SUM(przydzial_myszy + NVL(myszy_extra, 0)) suma
  FROM Kocury
);

SET SERVEROUTPUT ON;

--34
DECLARE
    funk Kocury.funkcja%TYPE;
BEGIN
    funk := '&funkcja';
    SELECT funkcja INTO funk FROM Kocury WHERE funkcja = funk GROUP BY funkcja;
    DBMS_OUTPUT.PUT_LINE('Znaleziono przynajmniej jednego kota o funkcji ' || funk);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Nie znaleziono zadnego kota o funkcji ' || funk);
END;
/
--35
DECLARE
  kocur Kocury%ROWTYPE;
  ps Kocury.pseudo%TYPE;
BEGIN
    ps := '&ps';
    
    DBMS_OUTPUT.PUT_LINE(ps);
    SELECT * INTO kocur FROM Kocury WHERE pseudo = ps;
    
    IF (NVL(kocur.przydzial_myszy, 0) + NVL(kocur.myszy_extra, 0)) * 12 > 700 THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' calkowity roczny przydzial myszy  > 700');
    ELSIF kocur.imie LIKE '%A%' THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' imie zawiera litere A (' || kocur.imie || ')');
    ELSIF EXTRACT(MONTH FROM kocur.w_stadku_od) = 5 THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' maj jest miesiacem przystapienia do stada');
    ELSE
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' nie odpowiada kryteriom');
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BRAK TAKIEGO KOTA');
END;
/
--36
DECLARE
    CURSOR kocuryC IS SELECT * FROM Kocury K JOIN Funkcje F ON K.funkcja = F.funkcja ORDER BY przydzial_myszy ASC FOR UPDATE OF prydzial_myszy;
    kocur kocuryC%ROWTYPE;
    suma NUMBER;
    pp NUMBER;
    zmiany NUMBER := 0;
BEGIN
    SELECT SUM(przydzial_myszy) INTO suma FROM Kocury;
    
    DBMS_OUTPUT.PUT_LINE('Calk. przydzial w stadku przed podwyzka ' || suma);
    
    LOOP
        EXIT WHEN suma > 1050;
    
        OPEN kocuryC;
        
        LOOP
            FETCH kocuryC INTO kocur;
            EXIT WHEN kocuryC%NOTFOUND;
            
            IF(NOT kocur.przydzial_myszy = kocur.MAX_MYSZY) THEN
                pp := ROUND(kocur.przydzial_myszy * 1.1, 0);
                
                IF pp > kocur.MAX_MYSZY THEN
                    pp := kocur.MAX_MYSZY;
                END IF;
                
                suma := suma + pp - kocur.przydzial_myszy;
                
                UPDATE Kocury
                SET przydzial_myszy = pp
                WHERE pseudo = kocur.pseudo;
                
                zmiany := zmiany + 1;
            END IF;
        END LOOP;
        
        CLOSE kocuryC;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Calk. przydzial w stadku ' || suma || '. Zmian - ' || zmiany);
END;

SELECT imie, przydzial_myszy FROM kocury ORDER BY przydzial_myszy DESC;
ROLLBACK;
/
--37
DECLARE
    CURSOR topK IS
        SELECT pseudo, przydzial_myszy + NVL(myszy_extra, 0) "zjada"
        FROM Kocury
        ORDER BY 2 DESC;
    kocur topK%ROWTYPE;
BEGIN
    OPEN topK;
    DBMS_OUTPUT.PUT_LINE('Nr   Pseudonim   Zjada');
    DBMS_OUTPUT.PUT_LINE('----------------------');
    
    FOR i IN 1..10
    LOOP
        FETCH topK INTO kocur;
        EXIT WHEN topK%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(RPAD(TO_CHAR(i), 5) || RPAD(kocur.pseudo, 10) || LPAD(TO_CHAR(kocur."zjada"), 7));
    END LOOP;
END;
/
--38
DECLARE
    CURSOR kocuryC IS SELECT * FROM Kocury WHERE funkcja = 'KOT' OR funkcja = 'MILUSIA';
    CURSOR szefC IS SELECT * FROM Kocury;
    kocur Kocury%ROWTYPE;
    szef Kocury%ROWTYPE;
    deep NUMBER;
    text_line VARCHAR2(200) := RPAD(TO_CHAR('Imie'), 10);
BEGIN
    deep := &deep;
    FOR i IN 1..deep
    LOOP
        text_line := text_line || '|  ' || RPAD(TO_CHAR('Szef ' || i), 10);
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(text_line);
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 10 + 13 * deep, '-'));
    
    OPEN kocuryC;
    
    LOOP
        FETCH kocuryC INTO kocur;
        EXIT WHEN kocuryC%NOTFOUND;
        text_line := RPAD(TO_CHAR(kocur.imie), 10);
        
        FOR i IN 1..deep
        LOOP
            IF(NOT kocur.szef IS NULL) THEN
                OPEN szefC;
                
                LOOP
                    FETCH szefC INTO szef;
                    EXIT WHEN szef.pseudo = kocur.szef;
                END LOOP;
                
                CLOSE szefC;
                kocur := szef;
                text_line := text_line || RPAD('|  ' || kocur.imie, 13);
            ELSE 
                text_line := text_line || RPAD(RPAD('|', 13), (deep - i + 1) * 13, RPAD('|', 13));
                EXIT;
            END IF;    
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE(text_line);
    END LOOP;
    
    CLOSE kocuryC;
END;
/
--39
DECLARE
    CURSOR bandyC IS SELECT * FROM Bandy;
    banda bandy%ROWTYPE;
    
    nr bandy.nr_bandy%TYPE;
    nazwa_bandy bandy.nazwa%TYPE;
    teren_bandy bandy.teren%TYPE;
    
    komunikat VARCHAR2(100) := NULL;
    
    banda_nr_exc EXCEPTION;
BEGIN
    nr := &nr;
    nazwa_bandy := '&nazwa_bandy';
    teren_bandy := '&teren_bandy';
    
    IF nr <= 0 THEN
        RAISE banda_nr_exc;
    END IF;
    
    OPEN bandyC;
    
    LOOP
        FETCH bandyC INTO banda;
        EXIT WHEN bandyC%NOTFOUND;
        
        IF nr = banda.nr_bandy THEN
            komunikat := komunikat || nr || ' ';
        END IF;
        IF nazwa_bandy = banda.nazwa THEN
            komunikat := komunikat || nazwa_bandy || ' ';
        END IF;
        IF teren_bandy = banda.teren THEN
            komunikat := komunikat || teren_bandy || ' ';
        END IF;
    END LOOP;
    
    IF(komunikat IS NULL) THEN
        INSERT INTO Bandy VALUES (nr, nazwa_bandy, teren_bandy, NULL);
    ELSE
        DBMS_OUTPUT.PUT_LINE(komunikat || ': juz istnieje');
    END IF;

    EXCEPTION
        WHEN banda_nr_exc THEN
            DBMS_OUTPUT.PUT_LINE('Numer bandy nie mo?e byc <= 0');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
ROLLBACK;
/
--40
CREATE OR REPLACE PROCEDURE UtworzBande(nr NUMBER, nazwa_bandy VARCHAR2, teren_bandy VARCHAR2) AS
    CURSOR bandyC IS SELECT * FROM Bandy;
    banda bandy%ROWTYPE;
    
    komunikat VARCHAR2(100) := NULL;
    
    banda_nr_exc EXCEPTION;
BEGIN
    
    IF nr <= 0 THEN
        RAISE banda_nr_exc;
    END IF;
    
    OPEN bandyC;
    
    LOOP
        FETCH bandyC INTO banda;
        EXIT WHEN bandyC%NOTFOUND;
        
        IF nr = banda.nr_bandy THEN
            komunikat := komunikat || nr || ' ';
        END IF;
        IF nazwa_bandy = banda.nazwa THEN
            komunikat := komunikat || nazwa_bandy || ' ';
        END IF;
        IF teren_bandy = banda.teren THEN
            komunikat := komunikat || teren_bandy || ' ';
        END IF;
    END LOOP;
    
    IF(komunikat IS NULL) THEN
        INSERT INTO Bandy VALUES (nr, nazwa_bandy, teren_bandy, NULL);
    ELSE
        DBMS_OUTPUT.PUT_LINE(komunikat || ': juz istnieje');
    END IF;

    EXCEPTION
        WHEN banda_nr_exc THEN
            DBMS_OUTPUT.PUT_LINE('Numer bandy nie mo?e byc <= 0');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
--41
CREATE OR REPLACE TRIGGER autonumeracja_bandy
BEFORE INSERT ON Bandy
FOR EACH ROW
BEGIN
  SELECT MAX(nr_bandy) + 1 INTO :NEW.nr_bandy FROM Bandy;
END;
/
--TEST
BEGIN
  UtworzBande(9, 'KOT', 'AAA');
END;
SELECT * FROM bandy;
ROLLBACK;
/
--42a
CREATE OR REPLACE PACKAGE wirus AS
    active BOOLEAN := FALSE;
    down BOOLEAN := FALSE;
    min_przydzial NUMBER;
END;
/
CREATE OR REPLACE PACKAGE BODY wirus AS
BEGIN
    NULL;
END;
/
CREATE OR REPLACE TRIGGER wirus_set
BEFORE UPDATE ON Kocury
BEGIN
    SELECT przydzial_myszy INTO wirus.min_przydzial FROM Kocury WHERE pseudo = 'TYGRYS';
END;
/
CREATE OR REPLACE TRIGGER wirus_przed
BEFORE UPDATE ON Kocury
FOR EACH ROW
WHEN(new.funkcja = 'MILUSIA')
DECLARE
    zmniejszenie_przedzialu EXCEPTION;
BEGIN
    wirus.active := TRUE;
    IF :NEW.przydzial_myszy < :OLD.przydzial_myszy THEN
        RAISE zmniejszenie_przedzialu;
    END IF;
    
    IF :NEW.przydzial_myszy - :OLD.przydzial_myszy <  0.1 * wirus.min_przydzial THEN
        :NEW.przydzial_myszy := :NEW.przydzial_myszy + 0.1 * wirus.min_przydzial ;
        :NEW.myszy_extra := :NEW.myszy_extra + 5;
        wirus.down := TRUE;
    END IF;
    
    EXCEPTION
        WHEN zmniejszenie_przedzialu THEN
            DBMS_OUTPUT.PUT_LINE('Nie mozesz zmniejszyc przedial!');
END;
/
CREATE OR REPLACE TRIGGER wirus_po
AFTER UPDATE ON Kocury
BEGIN
    IF wirus.active THEN
        wirus.active := FALSE;
        IF wirus.down THEN
            wirus.down := FALSE;
            UPDATE kocury SET przydzial_myszy = przydzial_myszy - 0.1 * wirus.min_przydzial WHERE pseudo = 'TYGRYS';
        ELSE
            UPDATE kocury SET myszy_extra = myszy_extra + 5 WHERE pseudo = 'TYGRYS';
        END IF;
    END IF;
END;
/
ALTER TRIGGER wirus_set ENABLE;
ALTER TRIGGER wirus_przed ENABLE;
ALTER TRIGGER wirus_po ENABLE;

ALTER TRIGGER wirus_set DISABLE;
ALTER TRIGGER wirus_przed DISABLE;
ALTER TRIGGER wirus_po DISABLE;

SELECT * FROM kocury WHERE funkcja = 'MILUSIA' OR pseudo = 'TYGRYS';
UPDATE kocury
SET przydzial_myszy = 20
WHERE funkcja = 'MILUSIA';
ROLLBACK;

--42b
/
CREATE OR REPLACE TRIGGER wirus_compound
FOR UPDATE ON Kocury
COMPOUND TRIGGER
    active BOOLEAN:=FALSE;
    down BOOLEAN:=FALSE;
    min_przydzial NUMBER;
    zmniejszenie_przedzialu EXCEPTION;
    
    BEFORE STATEMENT IS
    BEGIN
        SELECT 0.1 * przydzial_myszy INTO min_przydzial FROM Kocury WHERE pseudo = 'TYGRYS';
    END BEFORE STATEMENT;
    
    BEFORE EACH ROW IS
    BEGIN
        IF :NEW.funkcja = 'MILUSIA' THEN
            active := TRUE;
            
            IF (:NEW.przydzial_myszy < :OLD.przydzial_myszy) THEN
                :NEW.przydzial_myszy := :OLD.przydzial_myszy;
            END IF;
            IF :NEW.przydzial_myszy - :OLD.przydzial_myszy <  min_przydzial THEN
                :NEW.przydzial_myszy := :NEW.przydzial_myszy + 0.1 * wirus.min_przydzial ;
                :NEW.myszy_extra := :NEW.myszy_extra + 5;
                down := TRUE;
            END IF;
        END IF;
    END BEFORE EACH ROW;
    
    AFTER EACH ROW IS
    BEGIN
        NULL;
    END AFTER EACH ROW;
    
    AFTER STATEMENT IS
    BEGIN
        IF active THEN
            IF down THEN
                UPDATE kocury SET przydzial_myszy = przydzial_myszy - min_przydzial WHERE pseudo = 'TYGRYS';
            ELSE
                UPDATE kocury SET myszy_extra = myszy_extra + 5 WHERE pseudo = 'TYGRYS';
            END IF;
        END IF;
        active := FALSE;
        down := FALSE;
    END AFTER STATEMENT;
END;
/
ALTER TRIGGER wirus_compound DISABLE;

SELECT * FROM kocury WHERE funkcja = 'MILUSIA';
UPDATE kocury
SET przydzial_myszy = przydzial_myszy + 1
WHERE funkcja = 'MILUSIA';
ROLLBACK;
/
--43
DECLARE
    CURSOR bandyC IS SELECT * FROM Bandy ORDER BY nazwa;
    banda bandy%ROWTYPE;
    CURSOR funkcjeC IS SELECT * FROM Funkcje ORDER BY funkcja;
    funkcja funkcjeC%ROWTYPE;
    CURSOR kocuryC IS SELECT * FROM Kocury;
    kocur kocuryC%ROWTYPE;
    liczba_funkcji NUMBER := 0;
    sumaF NUMBER;
    sumaB NUMBER;
    sumaO NUMBER := 0;
    singlerow VARCHAR2(500);
BEGIN
    singlerow := RPAD('NAZWA BANDY', 15) || RPAD(' | PLEC', 8);
    
    OPEN funkcjeC;
    LOOP
        FETCH funkcjeC INTO funkcja;
        EXIT WHEN funkcjeC%NOTFOUND;
        singlerow := singlerow || ' | ' || RPAD(funkcja.funkcja, 10);
        liczba_funkcji := liczba_funkcji + 1;
    END LOOP;
    CLOSE funkcjeC;
    
    singlerow := singlerow || ' | ' || RPAD('SUMA', 10);
    DBMS_OUTPUT.PUT_LINE(singlerow);
    
    singlerow := RPAD('-', 36 + liczba_funkcji * 13, '-');
    DBMS_OUTPUT.PUT_LINE(singlerow);
    
    OPEN bandyC;
    LOOP
        FETCH bandyC INTO banda;
        EXIT WHEN bandyC%NOTFOUND;
        
        singlerow := RPAD(banda.nazwa, 15);
        singlerow := singlerow || ' | ' || RPAD('KOTKA', 5);
        sumaB := 0;
        
        OPEN funkcjeC;
        LOOP
            FETCH funkcjeC INTO funkcja;
            EXIT WHEN funkcjeC%NOTFOUND;
            sumaF := 0;
            
            OPEN kocuryC;
            LOOP
                FETCH kocuryC INTO kocur;
                EXIT WHEN kocuryC%NOTFOUND;
                IF(kocur.nr_bandy = banda.nr_bandy AND kocur.funkcja = funkcja.funkcja AND kocur.plec = 'D') THEN
                    sumaF := sumaF + NVL(kocur.przydzial_myszy, 0) + NVL(kocur.myszy_extra, 0);
                END IF;
            END LOOP;
            CLOSE kocuryC;
            
            singlerow := singlerow || ' | ' || RPAD(TO_CHAR(sumaF), 10);
            sumaB := sumaB + sumaF;
        END LOOP;
        CLOSE funkcjeC;
        
        singlerow := singlerow || ' | ' || RPAD(TO_CHAR(sumaB), 10);
        DBMS_OUTPUT.PUT_LINE(singlerow);
        
        singlerow := RPAD(banda.nazwa, 15);
        singlerow := singlerow || ' | ' || RPAD('KOCUR', 5);
        sumaO := sumaO + sumaB;
        sumaB := 0;
        
        OPEN funkcjeC;
        LOOP
            FETCH funkcjeC INTO funkcja;
            EXIT WHEN funkcjeC%NOTFOUND;
            sumaF := 0;
            
            OPEN kocuryC;
            LOOP
                FETCH kocuryC INTO kocur;
                EXIT WHEN kocuryC%NOTFOUND;
                IF(kocur.nr_bandy = banda.nr_bandy AND kocur.funkcja = funkcja.funkcja AND kocur.plec = 'M') THEN
                    sumaF := sumaF + NVL(kocur.przydzial_myszy, 0) + NVL(kocur.myszy_extra, 0);
                END IF;
            END LOOP;
            CLOSE kocuryC;
            
            singlerow := singlerow || ' | ' || RPAD(TO_CHAR(sumaF), 10);
            sumaB := sumaB + sumaF;
        END LOOP;
        CLOSE funkcjeC;
        
        singlerow := singlerow || ' | ' || RPAD(TO_CHAR(sumaB), 10);
        DBMS_OUTPUT.PUT_LINE(singlerow);
        sumaO := sumaO + sumaB;
    END LOOP;
    CLOSE bandyC;
    
    singlerow := RPAD('-', 36 + liczba_funkcji * 13, '-');
    DBMS_OUTPUT.PUT_LINE(singlerow);
    
    singlerow := RPAD('ZJADA RAZEM', 15);
    singlerow := singlerow || ' | ' || RPAD(' ', 5);
    
    OPEN funkcjeC;
    LOOP
        FETCH funkcjeC INTO funkcja;
        EXIT WHEN funkcjeC%NOTFOUND;
        sumaF := 0;
        
        OPEN kocuryC;
        LOOP
            FETCH kocuryC INTO kocur;
            EXIT WHEN kocuryC%NOTFOUND;
            IF(kocur.funkcja = funkcja.funkcja) THEN
                sumaF := sumaF + NVL(kocur.przydzial_myszy, 0) + NVL(kocur.myszy_extra, 0);
            END IF;
        END LOOP;
        CLOSE kocuryC;
        singlerow := singlerow || ' | ' || RPAD(TO_CHAR(sumaF), 10);
    END LOOP;
    CLOSE funkcjeC;
    
    singlerow := singlerow || ' | ' || RPAD(TO_CHAR(sumaO), 10);
    DBMS_OUTPUT.PUT_LINE(singlerow);
END;
/
--44
CREATE OR REPLACE FUNCTION podatek(pseudonim VARCHAR2)
RETURN NUMBER AS
    podstawowy NUMBER;
    podwladni NUMBER;
    wrogowie NUMBER;
    rok NUMBER;
BEGIN
    SELECT 0.05 * NVL(przydzial_myszy, 0), EXTRACT(YEAR FROM w_stadku_od) INTO podstawowy, rok FROM Kocury WHERE pseudo = pseudonim;
    SELECT COUNT(*) INTO podwladni FROM Kocury WHERE szef = pseudonim;
    SELECT COUNT(*) INTO wrogowie FROM Wrogowie_kocurow WHERE pseudo = pseudonim;
    
    IF podwladni > 0 THEN
        podwladni := 0;
    ELSE
        podwladni := 2;
    END IF;
    
    IF wrogowie > 0 THEN
        wrogowie := 0;
    ELSE
        wrogowie := 1;
    END IF;
    
    IF rok > 2010 THEN
        rok := 1;
    ELSE
        rok := 0;
    END IF;
    
    RETURN podstawowy + podwladni + wrogowie + rok;
END;
/
SELECT podatek('MALY') FROM dual;
/
--45
CREATE TABLE Dodatki_extra(pseudo VARCHAR2(15), dodatek NUMBER);

CREATE OR REPLACE TRIGGER zemsta_tygrysa
FOR UPDATE ON Kocury
COMPOUND TRIGGER
  active BOOLEAN:=FALSE;
  sqlQuery VARCHAR2(50);
  exist NUMBER;
  CURSOR milusieC IS SELECT * FROM Kocury WHERE funkcja = 'MILUSIE';
  milusie milusieC%ROWTYPE;

  BEFORE EACH ROW IS
  BEGIN
    IF :NEW.funkcja = 'MILUSIA' AND NOT SYS.LOGIN_USER = 'TYGRYS' THEN
      active := TRUE;
    END IF;
  END BEFORE EACH ROW;

  AFTER STATEMENT IS
  BEGIN
    IF active THEN
      OPEN milusieC;

      LOOP
        FETCH milusieC INTO milusie;
        EXIT WHEN milusieC%NOTFOUND;

        SELECT COUNT(*) INTO exist FROM dodatki_extra WHERE pseudo = milusie.pseudo;
        IF exist > 0 THEN
          sqlquery := 'UPDATE Dodatki_extra SET dodatek = dodatek - 10 WHERE funkcja = ''MILUSIA'';';
        ELSE
          sqlquery := 'INSERT INTO Dodatki_extra VALUES (' || TO_CHAR(milusie.pseudo) ||', -10);';
        END IF;

        EXECUTE IMMEDIATE sqlquery;
      END LOOP;

      active := FALSE;
    END IF;
  END AFTER STATEMENT;
END;
/
--46
CREATE TABLE Log(kto VARCHAR2(20), kiedy DATE, kotu VARCHAR2(10), operacja VARCHAR2(2000));
DROP TABLE Log;

CREATE OR REPLACE TRIGGER min_max_funkcja
BEFORE INSERT OR UPDATE ON Kocury
FOR EACH ROW
DECLARE
    min_num NUMBER;
    max_num NUMBER;
    operation VARCHAR2(15);
BEGIN
    SELECT min_myszy INTO min_num FROM Funkcje WHERE funkcja = :NEW.funkcja;
    SELECT max_myszy INTO max_num FROM Funkcje WHERE funkcja = :NEW.funkcja;
    
    operation := 'INSERTING';
    IF UPDATING THEN
        operation := 'UPDATING';
    END IF;
    
    IF :NEW.przydzial_myszy < min_num THEN
        INSERT INTO Log VALUES (SYS.LOGIN_USER, CURRENT_DATE, :NEW.pseudo, operation);
        :NEW.przydzial_myszy := min_num;
    ELSIF :NEW.przydzial_myszy > max_num THEN
        INSERT INTO Log VALUES (SYS.LOGIN_USER, CURRENT_DATE, :NEW.pseudo, operation);
        :NEW.przydzial_myszy := max_num;
    END IF;
END;


UPDATE kocury
SET przydzial_myszy = 31
WHERE pseudo = 'PUSZYSTA';
SELECT * FROM Log;
SELECT * FROM kocury WHERE pseudo = 'PUSZYSTA';
DELETE FROM LOG;
ROLLBACK;

INSERT INTO Kocury VALUES ('321', 'D', '321', 'KOT', NULL, NULL, 60, 0, NULL);
/


/* 19a | szef REF | trigger */

--47
CREATE OR REPLACE TYPE KocuryO AS OBJECT
(
 imie VARCHAR2(15),
 plec VARCHAR2(1),
 pseudo VARCHAR2(10),
 funkcja VARCHAR2(10),
 szef REF KocuryO,
 w_stadku_od DATE,
 przydzial_myszy NUMBER(3),
 myszy_extra NUMBER(3),
 nr_bandy NUMBER(2),
 MEMBER FUNCTION w_stadku_format RETURN VARCHAR2,
MEMBER FUNCTION pelny_przydzial RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY KocuryO AS
  MEMBER FUNCTION w_stadku_format RETURN VARCHAR2 IS
    BEGIN
      RETURN TO_CHAR(w_stadku_od, 'yyyy-mm-dd');
    END;
  MEMBER FUNCTION pelny_przydzial RETURN NUMBER IS
    BEGIN
      RETURN przydzial_myszy + NVL(myszy_extra, 0);
    END;
END;
/

CREATE OR REPLACE TYPE PlebsO AS OBJECT
(
  idn INTEGER,
  kot REF KocuryO,
  MEMBER FUNCTION dane_o_kocie RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY PlebsO AS
  MEMBER FUNCTION dane_o_kocie RETURN VARCHAR2 IS
      text VARCHAR2(500);
    BEGIN
      SELECT 'IMIE: ' || DEREF(kot).imie || ' PSEUDO ' || DEREF(kot).pseudo INTO text FROM dual;
      RETURN text;
    END;
END;
/

CREATE OR REPLACE TYPE ElitaO AS OBJECT
(
  idn INTEGER,
  kot REF KocuryO,
  sluga REF PlebsO,
  MEMBER FUNCTION pobierz_sluge RETURN REF PlebsO
);
/

CREATE OR REPLACE TYPE BODY ElitaO AS
  MEMBER FUNCTION pobierz_sluge RETURN REF PlebsO IS
    BEGIN
      RETURN sluga;
    END;
END;
/

CREATE OR REPLACE TYPE WpisO AS OBJECT
(
  idn INTEGER,
  dataWprowadzenia DATE,
  dataUsuniecia DATE,
  kot REF ElitaO,
  MEMBER PROCEDURE wyprowadz_mysz(dat DATE)
);
/

CREATE OR REPLACE TYPE BODY WpisO AS
  MEMBER PROCEDURE wyprowadz_mysz(dat DATE) IS
    BEGIN
      datausuniecia := dat;
    END;
END;
/

CREATE TABLE KocuryT OF KocuryO
(CONSTRAINT KocuryT_key PRIMARY KEY (pseudo));
/

CREATE TABLE PlebsT OF PlebsO
(CONSTRAINT PlebsT_key PRIMARY KEY (idn));
/

CREATE TABLE ElitaT OF ElitaO
(CONSTRAINT ElitaT_key PRIMARY KEY (idn));
/

CREATE TABLE WpisT OF WpisO
(CONSTRAINT WpisT_key PRIMARY KEY (idn));
/

INSERT
INTO KocuryT VALUES (KocuryO('MRUCZEK','M','TYGRYS', 'SZEFUNIO', NULL,'2002-01-01',103,33,1));
COMMIT;
/

DECLARE
    szef REF KocuryO;
BEGIN
    FOR k IN (SELECT * FROM Kocury WHERE szef = 'KURKA')
    LOOP
        SELECT REF(kot) INTO szef FROM KocuryT kot WHERE pseudo = k.szef;
        INSERT INTO KocuryT VALUES(KocuryO(k.imie, k.plec, k.pseudo, k.funkcja, szef, k.w_stadku_od, k.przydzial_myszy, k.myszy_extra, k.nr_bandy));
    END LOOP;
END;
/
INSERT INTO PlebsT
    SELECT PlebsO(ROWNUM, REF(K))
    FROM KocuryT K
    WHERE K.funkcja = 'KOT';
COMMIT;
/

INSERT INTO ElitaT
  SELECT ElitaO(ROWNUM, REF(K), NULL)
  FROM KocuryT K
  WHERE DEREF(K.szef).pseudo = 'TYGRYS'
        OR K.szef IS NULL;
COMMIT;
/

UPDATE ElitaT
SET sluga = (SELECT REF(T) FROM plebst T WHERE idn = 1)
WHERE DEREF(kot).pseudo = 'RAFA';
COMMIT;
/

INSERT INTO WpisT
  SELECT WpisO(ROWNUM, ADD_MONTHS(CURRENT_DATE, -TRUNC(DBMS_RANDOM.VALUE(0, 12))), NULL, REF(K))
  FROM ElitaT K;
COMMIT;
/

create or replace TRIGGER kocuryO_rozdzielanie_e
BEFORE INSERT ON ElitaT
FOR EACH ROW
WHEN(DEREF(new.kot).szef IS NOT NULL AND DEREF(DEREF(new.kot).szef).pseudo != 'TYGRYS')
BEGIN
    raise_application_error(-20111,'Elita moze byc tylko ten kto ma szefa Tygrysa lub nie ma w ogole');
END;
/
create or replace TRIGGER kocuryO_rozdzielanie_p
BEFORE INSERT ON PlebsT
FOR EACH ROW
WHEN(DEREF(new.kot).szef IS NULL OR DEREF(DEREF(new.kot).szef).pseudo = 'TYGRYS')
BEGIN
    raise_application_error(-20111,'Do plebsa moze nalezec tylko ten kto ma szefa innego od tygrysa!');
END;
/

-- Lab 18
SELECT Q1.imie, Q1.w_stadku_format() "Poluje od"
FROM KocuryT Q1 JOIN KocuryT Q2 ON Q2.imie = 'JACEK'
WHERE Q1.w_stadku_od < Q2.w_stadku_od
ORDER BY Q1.w_stadku_od DESC;

-- 19a
SELECT
  k.imie AS "Imie",
  k.funkcja AS "Funkcja",
  NVL(k.szef.pseudo, 'N/A') AS "Szef 1",
  NVL(k.szef.szef.pseudo, 'N/A') AS "Szef 2",
  NVL(k.szef.szef.szef.pseudo, 'N/A') AS "Szef 3"
FROM
  KocuryT k
WHERE
  k.funkcja IN ('KOT', 'MILUSIA');

-- Lab 23
SELECT k.imie, 12 * k.pelny_przydzial(), 'ponizej 864'
FROM KocuryT k
WHERE k.myszy_extra IS NOT NULL
      AND 12 * k.pelny_przydzial() < 864

UNION ALL

SELECT k.imie, 12 * k.pelny_przydzial(), '864'
FROM KocuryT k
WHERE myszy_extra IS NOT NULL
      AND 12 * k.pelny_przydzial() = 864

UNION ALL

SELECT k.imie, 12 * k.pelny_przydzial(), 'powyzej 864'
FROM KocuryT k
WHERE k.myszy_extra IS NOT NULL
      AND 12 * k.pelny_przydzial() > 864
ORDER BY 2 DESC;
/

-- Lab 34
DECLARE
  func KocuryT.funkcja%TYPE;
BEGIN
  SELECT k.funkcja INTO func FROM KocuryT k WHERE k.funkcja = '&funkcja' GROUP BY k.funkcja;
  DBMS_OUTPUT.PUT_LINE('ZNALEZIONO KOTA!');
  EXCEPTION
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('BRAK TAKIEGO KOTA');
END;
/

--Lab 35
DECLARE
  kocur KocuryO;
  ps VARCHAR2(15);
BEGIN
    ps := '&ps';
    
    DBMS_OUTPUT.PUT_LINE(ps);
    SELECT k KocuryO INTO kocur FROM KocuryT k WHERE k.pseudo = ps;
    
    IF kocur.pelny_przydzial() * 12 > 700 THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' calkowity roczny przydzial myszy  > 700');
    ELSIF kocur.imie LIKE '%A%' THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' imie zawiera litere A (' || kocur.imie || ')');
    ELSIF EXTRACT(MONTH FROM kocur.w_stadku_od) = 5 THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' maj jest miesiacem przystapienia do stada');
    ELSE
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' nie odpowiada kryteriom');
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BRAK TAKIEGO KOTA');
END;
/





--48
CREATE OR REPLACE TYPE KocuryV AS OBJECT
(
  imie VARCHAR2(15),
  plec VARCHAR2(1),
  pseudo VARCHAR2(10),
  funkcja VARCHAR2(10),
  szef REF KocuryV,
  w_stadku_od DATE,
  przydzial_myszy NUMBER(3),
  myszy_extra NUMBER(3),
  nr_bandy NUMBER(2),
MEMBER FUNCTION w_stadku_format RETURN VARCHAR2,
MEMBER FUNCTION pelny_przydzial RETURN NUMBER
);
/
CREATE OR REPLACE TYPE BODY KocuryV AS
  MEMBER FUNCTION w_stadku_format RETURN VARCHAR2 IS
    BEGIN
      RETURN TO_CHAR(w_stadku_od, 'yyyy-mm-dd');
    END;
  MEMBER FUNCTION pelny_przydzial RETURN NUMBER IS
    BEGIN
      RETURN przydzial_myszy + NVL(myszy_extra, 0);
    END;
END;
/

CREATE OR REPLACE TYPE KocuryVO AS OBJECT
(
  kot kocuryV,
  szef REF kocuryV
);
/



CREATE TABLE Plebs (
  idn INTEGER CONSTRAINT plebs_pk PRIMARY KEY,
  kot VARCHAR2(10) CONSTRAINT plebks_fk REFERENCES Kocury(pseudo)
);
CREATE TABLE Elita (
  idn INTEGER CONSTRAINT elita_pk PRIMARY KEY,
  kot VARCHAR2(10) CONSTRAINT elita_fk REFERENCES Kocury(pseudo),
  sluga NUMBER CONSTRAINT elita_sluga_fk REFERENCES Plebs(idn)
);

CREATE TABLE Wpis (
  idn INTEGER CONSTRAINT wpis_pk PRIMARY KEY,
  dataWprowadzenia DATE,
  dataUsuniecia DATE,
  kot NUMBER CONSTRAINT wpis_fk REFERENCES Elita(idn)
);
/
CREATE OR REPLACE VIEW Kocury_O OF KocuryV
WITH OBJECT IDENTIFIER (pseudo) AS
SELECT KocuryV(imie, plec, pseudo, funkcja, MAKE_REF(kocury_O, szef), w_stadku_od, przydzial_myszy, myszy_extra, nr_bandy)
FROM kocury;
/

--19a
SELECT
  k.imie AS "Imie",
  k.funkcja AS "Funkcja",
  NVL(DEREF(k.szef).pseudo, 'N/A') AS "Szef 1",
  NVL(DEREF(DEREF(k.szef).szef).pseudo, 'N/A') AS "Szef 2",
  NVL(DEREF(DEREF(DEREF(k.szef).szef).szef).pseudo, 'N/A') AS "Szef 3"
FROM
  Kocury_O k
WHERE
  k.funkcja IN ('KOT', 'MILUSIA');
/
CREATE OR REPLACE VIEW Plebs_O OF PlebsO
WITH OBJECT IDENTIFIER (idn) AS
SELECT idn, MAKE_REF(Kocury_O, kot) kot
FROM plebs;
/
CREATE OR REPLACE VIEW Elita_O OF ElitaO
WITH OBJECT IDENTIFIER (idn) AS
SELECT idn, MAKE_REF(Kocury_O, kot) kot, MAKE_REF(Plebs_O, sluga) sluga
FROM elita;
/
CREATE OR REPLACE VIEW Wpis_O OF WpisO
WITH OBJECT IDENTIFIER (idn) AS
SELECT idn, datawprowadzenia, Wpis.datausuniecia, MAKE_REF(Elita_O, kot) kot
FROM wpis;


INSERT INTO Plebs_O
  SELECT PlebsO(ROWNUM, REF(K))
  FROM Kocury_O K
  WHERE K.funkcja = 'KOT';
COMMIT;


INSERT INTO Elita_O
  SELECT ElitaO(ROWNUM, REF(K), NULL)
  FROM Kocury_O K
  WHERE K.szef = 'TYGRYS'
        OR K.szef IS NULL;
COMMIT;

UPDATE Elita_O
SET sluga = (SELECT REF(T) FROM plebs_o T WHERE idn = 1)
WHERE DEREF(kot).pseudo = 'RAFA';
COMMIT;

INSERT INTO Wpis_O
  SELECT WpisO(ROWNUM, ADD_MONTHS(CURRENT_DATE, -TRUNC(DBMS_RANDOM.VALUE(0, 12))), NULL, REF(K))
  FROM Elita_O K;
COMMIT;

-- JOIN na REF
SELECT * FROM wpis_o w JOIN (kocury_o k JOIN elita_o e ON e.kot = REF(k)) ON w.kot = REF(e);

-- Podzapytanie
SELECT ("p").dane_o_kocie() "Dane"
FROM kocury_o k JOIN (SELECT DEREF(e.pobierz_sluge()) "p" FROM elitat e)  ON ("p").kot = REF(k) ;

-- grupowanie
SELECT k.pelny_przydzial()/10 "Przydzial" FROM kocury_o k
GROUP BY k.pelny_przydzial() / 10
HAVING k.pelny_przydzial() / 10 > 10 ;



-- Lab 18
SELECT Q1.imie, Q1.w_stadku_format() "Poluje od"
FROM KocuryT Q1 JOIN KocuryT Q2 ON Q2.imie = 'JACEK'
WHERE Q1.w_stadku_od < Q2.w_stadku_od
ORDER BY Q1.w_stadku_od DESC;

-- Lab 23
SELECT k.imie, 12 * k.pelny_przydzial(), 'ponizej 864'
FROM KocuryT k
WHERE k.myszy_extra IS NOT NULL
      AND 12 * k.pelny_przydzial() < 864

UNION ALL

SELECT k.imie, 12 * k.pelny_przydzial(), '864'
FROM KocuryT k
WHERE myszy_extra IS NOT NULL
      AND 12 * k.pelny_przydzial() = 864

UNION ALL

SELECT k.imie, 12 * k.pelny_przydzial(), 'powyzej 864'
FROM KocuryT k
WHERE k.myszy_extra IS NOT NULL
      AND 12 * k.pelny_przydzial() > 864
ORDER BY 2 DESC;
/

-- Lab 34
DECLARE
  func KocuryT.funkcja%TYPE;
BEGIN
  SELECT k.funkcja INTO func FROM KocuryT k WHERE k.funkcja = '&funkcja' GROUP BY k.funkcja;
  DBMS_OUTPUT.PUT_LINE('ZNALEZIONO KOTA!');
  EXCEPTION
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('BRAK TAKIEGO KOTA');
END;
/

--Lab 35
DECLARE
  kocur KocuryV;
  ps VARCHAR2(15);
BEGIN
    ps := '&ps';
    
    DBMS_OUTPUT.PUT_LINE(ps);
    SELECT k KocuryV INTO kocur FROM Kocury_O k WHERE k.pseudo = ps;
    
    IF kocur.pelny_przydzial() * 12 > 700 THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' calkowity roczny przydzial myszy  > 700');
    ELSIF kocur.imie LIKE '%A%' THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' imie zawiera litere A (' || kocur.imie || ')');
    ELSIF EXTRACT(MONTH FROM kocur.w_stadku_od) = 5 THEN
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' maj jest miesiacem przystapienia do stada');
    ELSE
        DBMS_OUTPUT.PUT_LINE(kocur.pseudo || ' nie odpowiada kryteriom');
    END IF;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('BRAK TAKIEGO KOTA');
END;
/





-- 49
CREATE TABLE Myszy(nr_myszy NUMBER CONSTRAINT myszy_pk PRIMARY KEY,
                   lowca VARCHAR2(10) CONSTRAINT lowca_fk REFERENCES Kocury(pseudo),
                   zjadacz VARCHAR2(10) CONSTRAINT zajadacz_fk REFERENCES Kocury(pseudo),
                   waga_myszy NUMBER(3),
                   data_zlowienia DATE,
                   data_wydania DATE
);
SELECT * FROM myszy_tmp;
DROP TABLE myszy;
/
DECLARE
  from_date DATE := TO_DATE('2004-01-01');
  cat_date DATE;
  cat_date_record DATE;
  current_date DATE := TO_DATE('2024-01-16');
  max_month_diff INTEGER := MONTHS_BETWEEN(current_date, from_date);
  months_b INTEGER;
  extra_pseudo VARCHAR2(10) := 'TYGRYS';
  kocur_przydzial INTEGER;
  randFromDate DATE;
  randToDate DATE;
  kot_max INTEGER;

  suma INTEGER := 0;
  dostepnych INTEGER;

  TYPE MyszyTmp IS TABLE OF Myszy%ROWTYPE INDEX BY BINARY_INTEGER;
  myszyTmpTable MyszyTmp;
  myszyTmpIndex BINARY_INTEGER := 1;
  numer_myszy NUMBER := 1;

  CURSOR kocuryC IS
    SELECT *
    FROM Kocury
    ORDER BY przydzial_myszy + NVL(myszy_extra, 0), w_stadku_od;
  kocur Kocury%ROWTYPE;

  CURSOR avgsC IS
    SELECT CEIL(AVG(przydzial_myszy + NVL(myszy_extra, 0)))
    FROM kocury
    WHERE w_stadku_od < current_date;

  avgs INTEGER;

BEGIN
  OPEN kocuryC;

  LOOP
    FETCH kocuryC INTO kocur;
    EXIT WHEN kocuryC%NOTFOUND;

    IF kocur.w_stadku_od < from_date THEN
      cat_date := from_date;
    ELSE
      cat_date := kocur.w_stadku_od;
    END IF;

    months_b := MONTHS_BETWEEN(current_date, cat_date);
    kocur_przydzial := kocur.przydzial_myszy + NVL(kocur.myszy_extra, 0);

    OPEN avgsC;
    FETCH avgsC INTO avgs;
    CLOSE avgsC;

    FOR i IN 0..(months_b - 1) LOOP
      IF i = (months_b - 1) AND TRUNC(ADD_MONTHS(current_date, -i), 'MONTH') = TRUNC(kocur.w_stadku_od, 'MONTH') THEN
        randFromDate := kocur.w_stadku_od;
      ELSE
        randFromDate := TRUNC(ADD_MONTHS(current_date, -i), 'MONTH');
      END IF;

      randToDate := current_date;

      -- Ile kot mo?e wytworzy? i zje??
      kot_max := LEAST(kocur_przydzial, avgs);

      -- W?asna produkcja
      FOR j IN 1..kot_max LOOP
        myszyTmpTable(myszyTmpIndex).nr_myszy := numer_myszy;
        myszyTmpTable(myszyTmpIndex).zjadacz := kocur.pseudo;
        myszyTmpTable(myszyTmpIndex).lowca := kocur.pseudo;
        myszyTmpTable(myszyTmpIndex).waga_myszy := CEIL(DBMS_RANDOM.VALUE(16, 60));
        myszyTmpTable(myszyTmpIndex).data_zlowienia := randFromDate + DBMS_RANDOM.VALUE(0, randToDate - randFromDate);
        myszyTmpTable(myszyTmpIndex).data_wydania := current_date;

        myszyTmpIndex := myszyTmpIndex + 1;
        numer_myszy := numer_myszy + 1;
      END LOOP;

      IF avgs > kocur_przydzial THEN
        suma := suma + (avgs - kocur_przydzial);

        -- Powy?ej przydzia?u kota
        FOR k IN 1..(avgs - kocur_przydzial) LOOP
          INSERT INTO Myszy VALUES (
            numer_myszy,
            kocur.pseudo,
            NULL,
            CEIL(DBMS_RANDOM.VALUE(16, 60)),
            randFromDate + DBMS_RANDOM.VALUE(0, randToDate - randFromDate),
            current_date
          );
          numer_myszy := numer_myszy + 1;
        END LOOP;
      END IF;
    END LOOP;
  END LOOP;

  FORALL i IN 1..myszyTmpTable.COUNT
    INSERT INTO Myszy VALUES (
      myszyTmpTable(i).nr_myszy,
      myszyTmpTable(i).lowca,
      extra_pseudo,
      myszyTmpTable(i).waga_myszy,
      myszyTmpTable(i).data_zlowienia,
      myszyTmpTable(i).data_wydania
    );

  CLOSE kocuryC;
END;

/
CREATE OR REPLACE PROCEDURE przyjmij_myszy_od_kota(ps Kocury.pseudo%TYPE, data_z DATE) AS
  ile_pseudo NUMBER;

  TYPE MyszyTable IS TABLE OF MYSZY%ROWTYPE INDEX BY BINARY_INTEGER;
  lista_myszy MyszyTable;

  TYPE MyszyKotaType IS RECORD (nr_myszy MYSZY.nr_myszy%TYPE, waga_myszy MYSZY.waga_myszy%TYPE, data_zlowienia MYSZY.data_zlowienia%TYPE);
  TYPE MyszyKotaTable IS TABLE OF MyszyKotaType INDEX BY BINARY_INTEGER;
  upolowane_myszy MyszyKotaTable;

  indeks NUMBER;
  BEGIN
    SELECT  COUNT(*) INTO ile_pseudo FROM Kocury WHERE pseudo=ps;

    SELECT  MAX(nr_myszy) + 1 INTO indeks FROM Myszy;

    EXECUTE IMMEDIATE 'SELECT * FROM ZLOWIONE_MYSZY_' || ps || ' WHERE data_zlowienia=''' || data_z || ''''
    BULK COLLECT INTO upolowane_myszy;

    FOR i IN 1 .. upolowane_myszy.COUNT
    LOOP
      lista_myszy(i).nr_myszy := indeks;
      lista_myszy(i).waga_myszy := upolowane_myszy(i).waga_myszy;
      lista_myszy(i).data_zlowienia := upolowane_myszy(i).data_zlowienia;
      indeks := indeks + 1;
    END LOOP;

    FORALL i IN 1..lista_myszy.COUNT
    INSERT INTO Myszy VALUES(
      lista_myszy(i).nr_myszy,
      ps,
      NULL,
      lista_myszy(i).waga_myszy,
      lista_myszy(i).data_zlowienia,
      NULL
    );

    EXECUTE IMMEDIATE 'DELETE FROM ZLOWIONE_MYSZY_' || ps || ' WHERE data_zlowienia=''' || TO_DATE(data_z) || '''';
  END ;
/



CREATE OR REPLACE PROCEDURE wyplata AS
  koty_indeks NUMBER:=1;
  myszy_indeks NUMBER:=1;
  suma_przydzialow NUMBER:=0;
  przydzielono_mysz BOOLEAN;

  najblizsza_sroda DATE;

  TYPE MyszyTable IS TABLE OF Myszy%ROWTYPE INDEX BY BINARY_INTEGER;
  lista_myszy MyszyTable;

  TYPE Pair IS RECORD (pseudo Kocury.pseudo%TYPE, myszy NUMBER(3));
  TYPE PairTable IS TABLE OF Pair INDEX BY BINARY_INTEGER;
  lista_kotow PairTable;
  czy_wyplacono NUMBER;
  wyplata_juz_byla EXCEPTION;
  
  BEGIN
    SELECT NEXT_DAY(LAST_DAY(SYSDATE) - 7, 3) INTO najblizsza_sroda FROM Dual;
    
    SELECT COUNT(*) INTO czy_wyplacono FROM Myszy WHERE data_wydania = najblizsza_sroda;
    
    IF czy_wyplacono > 0 THEN
        RAISE wyplata_juz_byla;
    END IF;
    
    SELECT  * BULK COLLECT INTO lista_myszy
    FROM Myszy
    WHERE zjadacz IS NULL;

    SELECT pseudo, przydzial_myszy + NVL(myszy_extra, 0) BULK COLLECT INTO lista_kotow
    FROM kocury
    WHERE w_stadku_od <= NEXT_DAY(LAST_DAY(ADD_MONTHS(SYSDATE, -1)) - 7, 3)
    START WITH szef IS NULL
    CONNECT BY PRIOR pseudo = szef
    ORDER BY LEVEL ASC;

    FOR i IN 1 .. lista_kotow.COUNT
    LOOP
      suma_przydzialow := suma_przydzialow + lista_kotow(i).myszy;
    END LOOP;

    WHILE myszy_indeks <= lista_myszy.COUNT AND suma_przydzialow> 0
    LOOP
      przydzielono_mysz:=FALSE;
      WHILE NOT przydzielono_mysz
      LOOP
        IF lista_kotow(koty_indeks).myszy > 0 THEN
          lista_myszy(myszy_indeks).zjadacz       := lista_kotow(koty_indeks).pseudo;
          lista_myszy(myszy_indeks).data_wydania  := najblizsza_sroda;
          lista_kotow(koty_indeks).myszy          := lista_kotow(koty_indeks).myszy-1;
          suma_przydzialow := suma_przydzialow - 1;
          przydzielono_mysz := true;
          myszy_indeks := myszy_indeks + 1;
        END IF;
        koty_indeks := MOD(koty_indeks, lista_kotow.COUNT) + 1;
      END LOOP;
    END LOOP;

    FORALL i IN 1..lista_myszy.COUNT
    UPDATE  Myszy
    SET     data_wydania = lista_myszy(i).data_wydania,
      zjadacz = lista_myszy(i).zjadacz
    WHERE   nr_myszy = lista_myszy(i).nr_myszy;
    
    EXCEPTION
        WHEN wyplata_juz_byla THEN
            DBMS_OUTPUT.PUT_LINE('W tym miesiacu juz byla wyplata!!');
  END;
/