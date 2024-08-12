/* Baza Projekty, v. 2020-02-20 */

--USE master;
--DROP DATABASE Projekty;
--GO

--CREATE DATABASE Projekty;
--GO

--USE Projekty;
--GO

SET LANGUAGE polski;
GO

-------- USUŃ TABELE --------

DROP TABLE IF EXISTS Realizacje;
DROP TABLE IF EXISTS Projekty;
DROP TABLE IF EXISTS Pracownicy;
DROP TABLE IF EXISTS Stanowiska;

--------- CREATE - UTWÓRZ TABELE I POWIĄZANIA --------

CREATE TABLE Stanowiska
(
    nazwa      VARCHAR(10) PRIMARY KEY,
    placa_min  MONEY,
    placa_max  MONEY,
    CHECK (placa_min < placa_max)
);

CREATE TABLE Pracownicy
(
    id           INT NOT NULL PRIMARY KEY,
    nazwisko     VARCHAR(20) NOT NULL,
    szef         INT REFERENCES Pracownicy(id),
    placa        MONEY,
    dod_funkc    MONEY,
    stanowisko   VARCHAR(10) REFERENCES Stanowiska(nazwa),
    zatrudniony  DATETIME
);

CREATE TABLE Projekty
(
    id               INT IDENTITY(10,10) NOT NULL PRIMARY KEY,
    nazwa            VARCHAR(20) NOT NULL UNIQUE,
    dataRozp         DATETIME NOT NULL,
    dataZakonczPlan  DATETIME NOT NULL,
    dataZakonczFakt  DATETIME NULL,
    kierownik        INT REFERENCES Pracownicy(id),
    stawka           MONEY
);

CREATE TABLE Realizacje
(
    idProj  INT REFERENCES Projekty(id),
    idPrac  INT REFERENCES Pracownicy(id),
    godzin  REAL DEFAULT 8,
    PRIMARY KEY (idProj, idPrac)
);

GO

---------- INSERT - WSTAW DANE --------

INSERT INTO Stanowiska VALUES
('profesor',   4000, 6000),
('adiunkt',    3000, 4000),
('doktorant',  1900, 2300),
('sekretarka', 2500, 3500),
('techniczny', 2500, 3500),
('dziekan',    3700, 5800);

INSERT INTO Pracownicy VALUES
(1,  'Wachowiak', NULL, 5500,  900,   'profesor', '01-09-1990'),
(2,  'Jankowski',    1, 3500, NULL,    'adiunkt', '01-09-2000'),
(3,  'Fiołkowska',   1, 3550, NULL,    'adiunkt', '01-01-1995'),
(4,  'Mielcarz',     1, 5000,  500,   'profesor', '01-12-1990'),
(5,  'Różycka',      4, 3900,  300,   'profesor', '01-09-2011'),
(6,  'Mikołajski',   4, 2100, NULL,  'doktorant', '01-10-2017'),
(7,  'Wójcicki',     5, 2350, NULL,  'doktorant', '01-10-2015'),
(8,  'Listkiewicz',  1, 3200, NULL, 'sekretarka', '01-09-1990'),
(9,  'Wróbel',       1, 2900,  400, 'techniczny', '01-01-2009'),
(10, 'Andrzejewicz', 5, 3900, NULL,    'adiunkt', '01-01-2012'),
(11, 'Jankowski',    5, 3200, NULL, 'techniczny', '01-01-2000');

INSERT INTO Projekty VALUES
('e-learning',     '01-01-2017', '31-05-2018',         NULL, 5, 100),
('web service',    '10-11-2009', '31-12-2010', '20-04-2011', 4,  90),
('semantic web',   '01-09-2018', '01-09-2023',         NULL, 4,  85),
('neural network', '01-01-2011', '30-06-2012', '30-06-2012', 1, 120),
('analiza danych', '01-04-2019', '30-06-2021',         NULL, 10, 85);

INSERT INTO Realizacje VALUES
(10,  5, 8),
(10, 10, 6),
(10,  9, 2),
(20,  4, 8),
(20,  6, 8),
(20,  9, 2),
(30,  4, 8),
(30,  6, 6),
(30, 10, 6),
(30,  9, 2),
(40,  1, 8),
(40,  2, 4),
(40,  3, 4),
(40,  9, 2),
(50,  9, 2);

------------ SELECT --------

SELECT * FROM Stanowiska;
SELECT * FROM Pracownicy;
SELECT * FROM Projekty;
SELECT * FROM Realizacje;

SELECT id,nazwa, stawka
FROM Projekty;

SELECT [Nazwa projektu] = nazwa,
       dataRozp         AS [Data rozpoczecia projektu], 
       dataZakonczPlan  [Planowana data zakonczenia],
       dataZakonczFakt  data_zakonczenia_faktycznego,
       kierownik        'Kierownik projektu',
       stawka           "Stawka w PLN"
FROM   Projekty;

SELECT nazwa AS [nazwa stanowiska], placa_min AS[płaca minimalna na stanowisku]
FROM Stanowiska

SELECT UPPER(nazwa) AS [nazwa projektu]
FROM   Projekty;

SELECT nazwa, LEN(nazwa) AS [liczba znaków]
FROM Stanowiska

SELECT nazwa, 
       stawka * 8 AS [dniówka]
FROM   Projekty

SELECT  GETDATE() + 1      AS [co będzie jutro],
        2 + 3              AS [suma], 
       'piękny ' + 'tekst' AS [napis];

SELECT nazwisko, placa * 12 AS [roczny przychód z pensji]
FROM Pracownicy

SELECT nazwisko, DATEDIFF (month, 01-01-2020, zatrudniony) AS [mies.zatrudniony]
FROM Pracownicy

SELECT id,
       nazwisko,
       ISNULL(szef, id) AS [kto jest szefem]
FROM   Pracownicy

SELECT id,
       nazwisko,
       szef AS [kto jest szefem]
FROM   Pracownicy;

SELECT nazwisko, 
      (placa + ISNULL(dod_funkc, 0)) * 12 AS [roczne wynagrodzenie] 
FROM Pracownicy

SELECT * FROM Pracownicy;

SELECT nazwa, DATEDIFF(month, dataRozp, ISNULL(dataZakonczFakt, GETDATE())) AS [czas trwania]
FROM Projekty;

SELECT nazwisko,
       CAST(placa AS VARCHAR)  + ' zł'    AS placa_1,
       CONVERT(VARCHAR, placa) + ' zł'    AS placa_2,
       CONVERT(VARCHAR, zatrudniony, 103) AS data_zatrudnienia
FROM   Pracownicy;

SELECT id,
       nazwisko,
       ISNULL(CAST(szef AS CHAR(11)), 'szef szefów') AS [kto jest szefem]
FROM   Pracownicy

SELECT CONVERT(DECIMAL(10,2),2.0/4)

SELECT DISTINCT stanowisko
FROM   Pracownicy

SELECT stanowisko
FROM   Pracownicy;

SELECT DISTINCT kierownik
FROM Projekty

SELECT nazwa, placa_min
FROM Stanowiska
ORDER BY placa_min DESC 

SELECT  TOP 1 nazwa,dataRozp, kierownik
FROM Projekty
ORDER BY dataRozp DESC

SELECT id, nazwisko,placa, stanowisko
FROM Pracownicy
WHERE (stanowisko = 'adiunkt' OR stanowisko = 'doktorant') AND placa > 2200;

SELECT nazwa
FROM Projekty
WHERE nazwa LIKE '%web%'

SELECT nazwisko
FROM Pracownicy
WHERE szef IS NULL

SELECT id, nazwisko, placa, dod_funkc, (placa + dod_funkc) AS [pensja]
FROM Pracownicy
WHERE ISNULL((placa + dod_funkc), 0) > 3500

SELECT  DISTINCT stanowisko AS [nazwa],
        CASE stanowisko
            WHEN 'profesor' THEN 'badawcze'
            WHEN 'adiunkt' THEN 'badawcze'
            WHEN 'doktorant' THEN 'badawcze'
            ELSE                 'administracyjne'
        END AS [typ stanowiska]
FROM Pracownicy

SELECT id, nazwisko, placa, nazwa, placa_min
FROM Pracownicy
     CROSS JOIN Stanowiska
WHERE nazwa = "profesor" OR nazwa = "sekretarka"
ORDER BY nazwisko;
SELECT * FROM Pracownicy;
SELECT * FROM Projekty;

SELECT P.nazwisko,
       P.id,
       R.kierownik,
       R.nazwa
FROM   Pracownicy P
       CROSS JOIN Projekty R;
      
SELECT P.nazwisko,
       P.id,
       R.kierownik,
       R.nazwa
FROM   Pracownicy P
       CROSS JOIN Projekty R
WHERE  P.id = R.kierownik;

SELECT P.nazwisko,
       P.id,
       R.kierownik,
       R.nazwa
FROM   Pracownicy P
       INNER JOIN Projekty R
               ON P.id = R.kierownik;

SELECT DISTINCT P.nazwisko, 
       P.placa, 
       P.stanowisko, 
       S.placa_min, 
       S.placa_max
FROM Pracownicy P
     INNER JOIN Stanowiska S
                ON S.nazwa = P.stanowisko 
                    AND (P.stanowisko = 'doktorant') 
                    AND (P.placa > S.placa_max OR P.placa < S.placa_min)


SELECT Re.idPrac as [id],
       P.nazwisko,
       R.nazwa
FROM REalizacje Re  
      JOIN Pracownicy P
           ON Re.idPrac = P.id
      JOIN Projekty R
           ON Re.idProj = R.id
ORDER BY nazwisko

SELECT P1.id,
       P1.kierownik,
       P1.nazwa,
       P2.id,
       P2.kierownik,
       P2.nazwa
FROM   Projekty P1
       JOIN Projekty P2
         ON P1.id != P2.id; 
         
SELECT P1.id,
       P1.kierownik,
       P1.nazwa,
       P2.id,
       P2.kierownik,
       P2.nazwa
FROM   Projekty P1
       JOIN Projekty P2
         ON P1.id > P2.id;

SELECT P1.id,
       P1.kierownik,
       P1.nazwa,
       P2.id,
       P2.kierownik,
       P2.nazwa
FROM   Projekty P1
       JOIN Projekty P2
         ON P1.id > P2.id
            AND P1.kierownik = P2.kierownik;

SELECT P1.id,
       P1.nazwisko,
       P2.id,
       P2.nazwisko
FROM Pracownicy P1
      JOIN Pracownicy P2
         ON P1.nazwisko = P2.nazwisko
            AND P1.id > P2.id
SELECT P.nazwisko,
       P.id,
       R.kierownik,
       R.nazwa
FROM   Pracownicy P
       LEFT OUTER JOIN Projekty R
                    ON P.id = R.kierownik;  
SELECT P.nazwisko,
       P.id,
       R.kierownik,
       R.nazwa
FROM   Pracownicy P
       INNER JOIN Projekty R
               ON P.id = R.kierownik;

SELECT P1.nazwisko AS [pracowanik],
       P2.nazwisko AS [szef]
FROM Pracownicy P1
      RIGHT OUTER JOIN Pracownicy P2
         ON P1.szef = P2.id

SELECT DISTINCT S.nazwa
FROM   Pracownicy P INNER JOIN Stanowiska S
       ON P.stanowisko != S.nazwa

SELECT S.nazwa,
       P.id,
       P.nazwisko
FROM   Stanowiska S
       LEFT OUTER JOIN Pracownicy P
                    ON S.nazwa = P.stanowisko;

SELECT S.nazwa
FROM   Stanowiska S
       LEFT OUTER JOIN Pracownicy P
                    ON S.nazwa = P.stanowisko
WHERE  P.id IS NULL;

SELECT P.id,
       P.nazwisko
FROM Pracownicy P
       LEFT OUTER JOIN Projekty R
                        ON P.id = R.kierownik
WHERE R.kierownik IS NULL;

SELECT  P.nazwisko
FROM Pracownicy P
       LEFT OUTER JOIN Realizacje Re
                        ON P.id = Re.idPrac
                            AND Re.idProj = '10'
WHERE Re.idPrac IS NULL;

SELECT  P.nazwisko,
        R.id AS [kieruje projektem],
        Re.idPrac AS [pracuje w projekcie]
FROM Pracownicy P
        LEFT OUTER JOIN Projekty R
                        ON P.id = R.kierownik
       LEFT OUTER JOIN Realizacje Re
                        ON R.kierownik = Re.idPrac                     
WHERE Re.idPrac IS NULL AND R.id IS NOT NULL;

SELECT P1.*
FROM   Projekty P1
       LEFT OUTER JOIN Projekty P2
                    ON P1.stawka > P2.stawka
WHERE  P2.id IS NULL;

SELECT * FROM Stanowiska;
SELECT * FROM Pracownicy;
SELECT * FROM Projekty;
SELECT * FROM Realizacje;

SELECT *
FROM   Projekty
WHERE  stawka > (SELECT stawka
                 FROM   Projekty
                 WHERE  nazwa = 'e-learning');

SELECT nazwisko
FROM Pracownicy
WHERE placa > (SELECT placa
               FROM Pracownicy
               WHERE nazwisko = 'Różycka');

SELECT *
FROM   Pracownicy
WHERE  stanowisko IN (SELECT nazwa
                      FROM   Stanowiska
                      WHERE  placa_min > 2500)

SELECT nazwisko
FROM Pracownicy 
WHERE id NOT IN (SELECT kierownik
             FROM Projekty);

SELECT nazwisko
FROM Pracownicy
WHERE id NOT IN (SELECT idPrac
                 FROM Realizacje
                 WHERE idProj = 10);

SELECT nazwisko
FROM Pracownicy
WHERE id IN (SELECT idPrac
            FROM Realizacje
            WHERE idProj IN (SELECT id
                              FROM Projekty
                              WHERE nazwa = 'e-learning'));

SELECT *
FROM   Projekty
WHERE  stawka > ALL (SELECT stawka
                 FROM   Projekty
                 WHERE  nazwa IN ('e-learning', 'semantic web'));

SELECT nazwa
FROM   Stanowiska
WHERE  nazwa != ALL (SELECT stanowisko
                     FROM   Pracownicy);

SELECT nazwisko,
       stanowisko
FROM   Pracownicy
WHERE  stanowisko != 'adiunkt'
       AND placa > SOME (SELECT placa
                         FROM   Pracownicy
                         WHERE  stanowisko = 'adiunkt');

SELECT nazwisko,
       placa
FROM Pracownicy
WHERE placa >= ALL (SELECT placa
                   FROM Pracownicy);

SELECT *
FROM   Pracownicy P
WHERE  P.placa > (SELECT S.placa_max
                  FROM   Stanowiska S
                  WHERE  S.nazwa = P.stanowisko);

SELECT P.nazwisko,
       P.stanowisko,
       P.placa,
       S.nazwa,
       S.placa_max,
       CASE WHEN P.placa > S.placa_max
            THEN 1
            ELSE 0
       END AS 'placa > placa_max ?'
FROM   Pracownicy P
       JOIN Stanowiska S
         ON P.stanowisko = S.nazwa;

SELECT R.id,
       R.nazwa,
       R.stawka,
       R.stawka * 40 AS [tygodniówka],
       R.kierownik,
       P.nazwisko,
       P.placa
FROM Projekty R
        INNER JOIN Pracownicy P
                    ON R.kierownik = P.id;

SELECT R.nazwa
FROM Projekty R
WHERE R.stawka * 40 > (SELECT P.placa
                        FROM Pracownicy P
                        WHERE R.kierownik = P.id);

SELECT P1.nazwisko,
       P1.id
FROM Pracownicy P1
WHERE P1.nazwisko IN (SELECT P2.nazwisko
                FROM Pracownicy P2
                WHERE P1.id != P2.id);

SELECT P.*
FROM   Pracownicy P
       INNER JOIN Stanowiska S
               ON P.stanowisko = S.nazwa
WHERE  P.placa > S.placa_max;
  
SELECT P1.nazwisko
FROM   Pracownicy P1
WHERE  P1.stanowisko = 'profesor'
       AND NOT EXISTS (SELECT *
                       FROM   Pracownicy P2
                       WHERE  P2.stanowisko = 'doktorant'
                              AND P2.szef = P1.id);


SELECT id,
       nazwisko
FROM   Pracownicy
WHERE  id NOT IN (SELECT szef
                  FROM   Pracownicy);
SELECT id,
       nazwisko
FROM   Pracownicy P1
WHERE  NOT EXISTS (SELECT 1
                   FROM   Pracownicy P2
                   WHERE  P2.szef = P1.id);

SELECT nazwisko
FROM Pracownicy AS P
WHERE NOT EXISTS (SELECT idProj
                  FROM Realizacje As R
                  WHERE P.id = R.idPrac);

SELECT * FROM Stanowiska;
SELECT * FROM Pracownicy;
SELECT * FROM Projekty;
SELECT * FROM Realizacje;

SELECT COUNT(*)   'liczba pracowników',
       AVG(placa) 'średnia płaca'
FROM   Pracownicy
WHERE id In (SELECT idPrac
              FROM Realizacje
              WHERE idProj = 10)

SELECT P1.nazwisko, P1.placa
FROM Pracownicy P1
Where P1.placa IN (SELECT MAX(P2.placa) 'najwieksza'
                FROM Pracownicy P2)

SELECT  P1.stanowisko, P1.nazwisko, P1.placa
FROM Pracownicy P1
WHERE P1.placa IN (SELECT MAX(placa)
                        FROM Pracownicy P2
                        WHERE P2.stanowisko IN (SELECT stanowisko
                                           FROM Pracownic



SELECT COUNT(stanowisko) AS 'ile stanowisk'
FROM   Pracownicy;

SELECT COUNT(DISTINCT stanowisko) AS 'ile różnych stanowisk'
FROM   Pracownicy;

SELECT COUNT(DISTINCT idPrac) AS 'ilu różnych pracowników'
FROM Realizacje

SELECT SUM(dod_funkc) AS 'suma dodatków funkcyjnych'
FROM   Pracownicy;

SELECT SUM(dod_funkc) AS 'suma dodatków funkcyjnych'
FROM   Pracownicy
WHERE  dod_funkc IS NOT NULL;

SELECT COUNT(DISTINCT szef) AS 'liczba szefów'
FROM Pracownicy

SELECT   stanowisko,
         COUNT(*)   'liczba pracowników',
         AVG(placa) 'średnia płaca'
FROM     Pracownicy
GROUP BY stanowisko;

SELECT szef, 
      MIN(placa) as 'minimum',
      MAX(placa) as 'maximum'
FROM Pracownicy
WHERE szef IS NOT NULL
GROUP BY szef;

SELECT *
FROM   Stanowiska S
       LEFT JOIN Pracownicy P
              ON S.nazwa = P.stanowisko;

SELECT   S.nazwa,
         COUNT(*)        AS 'COUNT(*)',
         COUNT(S.nazwa)  AS 'COUNT(S.nazwa)',
         COUNT(P.id)     AS 'COUNT(P.id)'
FROM     Stanowiska S
         LEFT JOIN Pracownicy P
                ON S.nazwa = P.stanowisko
GROUP BY S.nazwa;

SELECT P.szef, 
       COUNT(szef) as 'ilu podwładnych'
FROM Pracownicy P
GROUP BY P.szef 

SELECT id, 
       nazwisko, 


SELECT   stanowisko,
         COUNT(*)   'liczba pracowników',
         AVG(placa) 'średnia płaca'
FROM     Pracownicy
GROUP BY stanowisko
HAVING   MIN(placa) > 3000;    

SELECT P.nazwisko
        COUNT(idProj) as 'liczba różnych projektów'
FROM Pracownicy P
       JOIN Realizacje R
        ON P.id = R.idPrac
GROUP BY R.idProj
HAVING P.stanowisko 


SELECT P1.nazwisko, 
       COUNT(nazwisko) as 'liczba'
FROM Pracownicy P1
       join Pracownicy P2
       on P1.id = P2.id
GROUP BY P1.nazwisko
HAVING P1.id != P2.id

SELECT nazwisko,
       placa,
       '> 3500' [przedzial]
FROM   Pracownicy
WHERE  placa > 3500
UNION -- ALL
SELECT nazwisko,
       placa,
       '<= 2500'
FROM   Pracownicy
WHERE  placa <= 2500;

SELECT nazwisko,
       placa
FROM   Pracownicy
WHERE  placa <= 2900
EXCEPT
SELECT nazwisko,
       placa
FROM   Pracownicy
WHERE  placa > 2500;

SELECT nazwisko,
       placa
FROM   Pracownicy
WHERE  placa > 2500
INTERSECT
SELECT nazwisko,
       placa
FROM   Pracownicy
WHERE  placa <= 3200;


SELECT nazwa, 
       DataZakonczPlan as 'DataZakonczenia',
       'projekt trwa' as 'STATUS'
FROM Projekty
WHERE dataZakonczFakt IS NULL
UNION --ALL
SELECT nazwa,
       dataZakonczPlan as 'DataZakonczenia',
       'projekt zakoczony' as 'STATUS'
FROM Projekty
WHERE dataZakonczFakt IS NOT NULL;


SELECT AVG(liczba)
FROM   (SELECT   COUNT(*) AS liczba
        FROM     Pracownicy
        GROUP BY stanowisko) AS Tabela;

SELECT id, nazwisko, placa, dod_funkc, (placa + dod_funkc) AS [pensja]
FROM (SELECT ISNULL((placa + dod_funkc), 0) > 3500
       FROM Pracownicy);

SELECT * FROM Stanowiska;
SELECT * FROM Pracownicy;
SELECT * FROM Projekty;
SELECT * FROM Realizacje;

CREATE VIEW Adiunkci(nazwisko, staz, zarobki)
AS
(
    SELECT  nazwisko, 
            DATEDIFF(YEAR, zatrudniony, GETDATE()), 
            placa + ISNULL(dod_funkc, 0)
    FROM    Pracownicy
    WHERE   stanowisko = 'adiunkt'
);
GO

SELECT * 
FROM   Adiunkci;

EXEC sp_helptext 'Adiunkci';

EXEC sp_tables   
   @table_name = '%',
   @table_owner = 'dbo',
   @table_type = "'view'";

EXEC sp_depends 'Adiunkci';

CREATE VIEW AktualneProjekty(nazwa, kierownik, licz pracowników)
AS
(
    SELECT R.nazwa,
           R.kierownik IN (SELECT P.nazwisko FROM Pracownicy P WHERE R.kierownik = P.id),
           COUNT(R.id IN (SELECT RE.idProj FROM Realizacje RE WHERE R.id = RE.idProj))
    FROM   Projekty R
    WHERE  R.dataZakonczFakt IS NULL
);
GO

SELECT *
FROM AktualneProjekty;


EXEC sp_helptext 'AktualneProjekty';

CREATE TABLE #Adiunkci
(
    nazwisko VARCHAR(50),
    staz     INT,
    zarobki  MONEY
);

GO

INSERT INTO #Adiunkci
SELECT nazwisko, 
       DATEDIFF(YEAR, zatrudniony, GETDATE()), 
       placa + ISNULL(dod_funkc, 0)
FROM   Pracownicy
WHERE  stanowisko = 'adiunkt';

SELECT nazwisko, 
       DATEDIFF(YEAR, zatrudniony, GETDATE()) staz, 
       placa + ISNULL(dod_funkc, 0) zarobki
INTO   #Adiunkci
FROM   Pracownicy
WHERE  stanowisko = 'adiunkt';

SELECT * 
FROM   #Adiunkci;

DECLARE @Adiunkci TABLE
(
    nazwisko VARCHAR(50),
    staz     INT,
    zarobki  MONEY
);

INSERT INTO @Adiunkci
SELECT nazwisko, 
       DATEDIFF(YEAR, zatrudniony, GETDATE()), 
       placa + ISNULL(dod_funkc, 0)
FROM   Pracownicy
WHERE  stanowisko = 'adiunkt';

SELECT * 
FROM   @Adiunkci;

UPDATE @Adiunkci
SET    zarobki *= 1.1;

SELECT * 
FROM   @Adiunkci;

SELECT *
FROM   (VALUES (1, 'a'),
               (2, 'b')) AS T(x, y);

WITH CTE_Adiunkci(nazwisko, staz, zarobki)
AS
(
    SELECT nazwisko, 
           DATEDIFF(YEAR, zatrudniony, GETDATE()), 
           placa + ISNULL(dod_funkc, 0)
    FROM   Pracownicy
    WHERE  stanowisko = 'adiunkt'
)
SELECT *
FROM   CTE_Adiunkci;

SELECT SCHEMA_NAME()

SELECT*
FROM dbo.Pracownicy