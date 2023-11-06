USE kawa;

/*zmiana typu danych*/
ALTER TABLE 
  coffee MODIFY COLUMN Data_zamowienia date;
  
ALTER TABLE coffee
ADD Miasto_ID INT AUTO_INCREMENT PRIMARY KEY;

  
  /*Tworzenie nowych tabel*/
  CREATE TABLE klienci(
Klient_ID char(50) PRIMARY KEY NOT NULL,
Klient_Imie char (70),
Karta_lojalnościowa char (5)
);

CREATE TABLE Miasto (
    Miasto_ID INT AUTO_INCREMENT PRIMARY KEY,
    Adres CHAR(70),
    Miasto CHAR(70),
    Kraj CHAR(70)
);

CREATE TABLE Produkt(
Produkt_ID char(50) PRIMARY KEY NOT NULL,
Nazwa_produktu char (70),
Rodzaj_kawy char (70)
);

CREATE TABLE Szczegóły_zamówienia(
Zamowienie_ID char(30),
Cena float,
Produkt_ID char (50),
Ilość_zamówienia INT,
Klient_ID char(50),
FOREIGN KEY (Produkt_ID) REFERENCES Produkt(Produkt_ID)
);

CREATE TABLE Zamowienia(
Zamowienie_ID char(30) PRIMARY KEY NOT NULL,
Klient_ID CHAR(50),
Produkt_ID char (50),
Miasto_ID INT,
Data_zamowienia DATE,
Cena float,
FOREIGN KEY (Miasto_ID) REFERENCES Miasto(Miasto_ID),
FOREIGN KEY (Produkt_ID) REFERENCES Produkt(Produkt_ID),
FOREIGN KEY (Klient_ID) REFERENCES klienci(Klient_ID)
);


/*zmiana typu danych*/
ALTER TABLE 
  Zamowienia MODIFY COLUMN Data_zamowienia date;

CREATE TABLE Kalendarz
(
    Data DATE
);

/*Uzupełnienie przygotowanych tabel*/

INSERT INTO klienci (Klient_ID, Klient_Imie, Karta_lojalnościowa)
SELECT DISTINCT Klient_ID, Klient_Imie, Karta_lojalnościowa
FROM coffee AS c
ON DUPLICATE KEY UPDATE
    Klient_ID = c.Klient_ID;

INSERT INTO Miasto (Adres, Miasto, Kraj)
SELECT Adres, Miasto, Kraj
FROM coffee;

/*Zmiana nazwy kolumny w tabeli produkty*/

ALTER TABLE produkt
CHANGE Nazwa_produktu Rodzaj_wypalania char (70);

/*Kontynuacja uzupełniania przygotowanych tabel*/
INSERT INTO produkt (Produkt_ID, Rodzaj_wypalania, Rodzaj_kawy)
SELECT DISTINCT Produkt_ID, Rodzaj_wypalania, Rodzaj_kawy
FROM coffee;

INSERT INTO Szczegóły_zamówienia (Zamowienie_ID, Cena, Produkt_ID, Ilość_zamówienia, Klient_ID)
SELECT Zamowienie_ID, Cena_produktu, Produkt_ID, Ilość_zamowienia, Klient_ID
FROM coffee;

INSERT INTO Zamowienia (Zamowienie_ID, Klient_ID, Produkt_ID, Miasto_ID, Data_zamowienia, Cena)
SELECT 
    Zamowienie_ID,
    Klient_ID,
    Produkt_ID,
    Miasto_ID,
    Data_zamowienia,
    Cena_produktu
FROM coffee AS c
ON DUPLICATE KEY UPDATE
    Klient_ID = c.Klient_ID,
    Produkt_ID = c.Produkt_ID,
    Miasto_ID = c.Miasto_ID,
    Data_zamowienia = c.Data_zamowienia,
    Cena = c.Cena_produktu;
    
    /*dodanie dat do kalendarza*/
INSERT INTO Kalendarz (Data)
SELECT DATE_ADD('2019-01-01', INTERVAL n DAY) AS Data
FROM (
    SELECT n
    FROM (
        SELECT (t4*1000 + t3*100 + t2*10 + t1) AS n
        FROM
            (SELECT 0 AS t1 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t1,
            (SELECT 0 AS t2 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t2,
            (SELECT 0 AS t3 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t3,
            (SELECT 0 AS t4 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) t4
    ) AS numbers
    WHERE n BETWEEN 0 AND DATEDIFF('2022-12-31', '2019-01-01')
) AS valid_dates;




  



    
