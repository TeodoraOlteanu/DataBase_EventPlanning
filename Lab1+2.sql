
INSERT INTO Person(id_person, Name)VALUES (1, 'William Anderson')
INSERT INTO Person(id_person, Name)VALUES (2, 'Andrada Marinescu')
INSERT INTO Person(id_person, Name)VALUES (3, 'Bill Shakespeare')
INSERT INTO Person(id_person, Name)VALUES (4, 'Melody Williams')
INSERT INTO Person(id_person, Name)VALUES (5, 'Kurt Koby')
INSERT INTO Person(id_person, Name)VALUES (7, 'Gregory McAdams')

INSERT INTO Catering_Firma(id_catering, Name, Typ)VALUES (1, 'EnjoyFlowers','FlowerShop'),
														(2, 'Vivre','Decoration'),
														(3, 'Delicatessen','Food'),
														(4, 'Calibra','Food'),
														(5, 'Lorlelei','Decoration')
INSERT INTO Catering_Firma(id_catering, Typ) VALUES (6, 'Decoration')

CREATE TABLE extra
(id_ticket INT NOT NULL, id_event INT NOT NULL, nume varchar(30),
PRIMARY KEY(id_ticket,id_event), 
FOREIGN KEY (id_ticket) REFERENCES Ticket, 
FOREIGN KEY (Id_event) REFERENCES Event)

CREATE TABLE extra2
(id_catering int, id_location int, name varchar(30)
PRIMARY KEY (id_catering, id_location)
CONSTRAINT FK_extra2_Location FOREIGN KEY (id_location) REFERENCES Location,
FOREIGN KEY (id_catering) REFERENCES Catering_Firma)



--Am incercat sa adaug valori in tabelul Ticket si la id_people mi a dat eroare probabil din cauza ca exista o legatura cu pk din tabelul
--people si fk id_people, iar eu nu pot adauga valoare la un foreign key a carei pk nu are valoare
INSERT INTO Ticket(id_ticket, id_people, is_VIP, time) VALUES(10, 10, 'False', '20:00')

DELETE FROM Person WHERE id_person = '6' AND Name='fff'

--LIKE
--DELETE FROM Event_Planner WHERE Name LIKE 'B%' sterge Baggings Frodo
DELETE FROM Review WHERE Review LIKE 'I%'--sterge review urile care incep cu I
--BETWEEN
DELETE FROM Catering_Firma WHERE Price BETWEEN '2000' AND '2500';
--IN(ohne geschachtelte Abfrage)
DELETE From Event WHERE id_event IN (SELECT id_event FROM Enrolled WHERE id_catering='2')
--Eine zusammengesetzte Bedingung mit logischen Operatoren
UPDATE Event Set Max_People=60 WHERE (Name = 'Wedding' OR Name='Baptism') AND Planner_id='1'
--IS [NOT] NULL
UPDATE Catering_Firma SET Price=1000 WHERE Price IS NULL

--datile evenimentelor unde apar VIP
SELECT id_event AS 'Events with VIPs' FROM Event
INTERSECT
SELECT id_event FROM Ticket WHERE is_VIP='true'

DELETE FROM Review WHERE id_review=1


--b

--uneste eventurile care au loc in Washington si fiecare firma de catering care serveste la event
SELECT E.Name, C.Name FROM Event E                                                                     --INNER JOIN
INNER JOIN Enrolled En
ON E.id_event = En.id_event																				--ANY
INNER JOIN Catering_Firma C
ON C.id_catering=En.id_catering
--WHERE En.id_catering = ANY(SELECT id_catering FROM Catering_Firma WHERE Typ='Decoration')
WHERE E.location=ANY(SELECT L.location_id FROM Location L WHERE L.city='Washington')                   --geschachtelt


SELECT E.Name, L.city, L.street, L.number, EP.Name AS 'Event Planner' FROM Event E
INNER JOIN Location L                                                                                  --INNER JOIN
ON L.location_id=E.location
INNER JOIN Event_Planner EP
ON EP.id_planner=E.Planner_id																			--INTERSECT
INTERSECT
SELECT E.Name, L.city, L.street, L.number, EP.Name FROM Event E, Location L, Event_Planner EP
WHERE L.city='Washington'


SELECT E.Name, P.Name AS 'Participants', E.Date FROM Event E                                                             --INNER JOIN
INNER JOIN people_event PE
ON E.id_event=PE.id_event
INNER JOIN Person P
ON P.id_person=PE.id_person

--INSERT INTO Staff(id_employee,Name,Job_Assigned,Salary) VALUES (6, 'Frodo Baggings','Assistant',3000)   --LEFT OUTER JOIN

--afiseaza toti angajatii care lucreaza la un event fara eventurile Baby Shower si Baptism
SELECT S.Name, E.Name FROM Staff S
LEFT OUTER JOIN Staff_Event SE
ON SE.id_employee=S.id_employee
LEFT OUTER JOIN Event E
ON E.id_event=SE.id_event
EXCEPT                                                                             --EXCEPT
SELECT S.Name, E.Name 
FROM Staff S, event E
WHERE E.Name IN ('BabyShower', 'Baptism')                                            --IN

--uneste toti participantii care iau parte la eventurile Wedding si Baptism
SELECT T.is_VIP, P.Name , E.Name FROM Ticket T                                                  --RIGHT OUTER JOIN
RIGHT OUTER JOIN Person P
ON P.id_person=T.id_people
RIGHT OUTER JOIN Event E
ON E.id_event=T.id_event
WHERE E.Planner_id=1
UNION
SELECT T.is_VIP, P.Name , E.Name FROM Ticket T                                                  --RIGHT OUTER JOIN
RIGHT OUTER JOIN Person P
ON P.id_person=T.id_people
RIGHT OUTER JOIN Event E
ON E.id_event=T.id_event
WHERE E.Planner_id=2

--INSERT INTO Event_Planner(id_planner, Name) VALUES (6,'Bogdan Teches')
--INSERT INTO Event(id_event) VALUES (6)

--uneste primele 6 eventuri cu event plannerul respectiv si locatia
SELECT TOP(5) E.Name, EP.Name, L.city, L.street, L.number 
FROM Event E                                                -- FULL OUTER JOIN
FULL OUTER JOIN Event_Planner EP
ON EP.id_planner=E.Planner_id
FULL OUTER JOIN Location L
ON L.location_id=E.location
ORDER BY E.Date


--afiseaza fiecare persoana care a lasat un review la un event, ordonand dupa data publicarii review
SELECT DISTINCT P.Name, R.Date, E.Name FROM Person P
INNER JOIN Review R
ON R.id_people=P.id_person
INNER JOIN Event E
ON E.id_event=R.id_event
ORDER BY R.Date



--SELECT C.Name
--FROM Catering_Firma C, Enrolled En
--WHERE C.id_catering=En.id_catering AND En.id_event=1
--UNION
--SELECT C.Name
--FROM Catering_Firma C, Enrolled En
--WHERE C.id_catering=En.id_catering AND En.id_event=2

----------------------------------------------------------------------------------------------------------------------------

--SELECT * FROM Catering_Firma
--Where Price < ANY(SELECT Price FROM Catering_Firma WHERE Typ='Decoration') AND Typ='Decoration'


SELECT Job_Assigned FROM Staff
WHERE FLOOR(DATEDIFF(DAY, Birth_Date, CURRENT_TIMESTAMP) / 365.25)>=16 
GROUP BY Job_Assigned                                                                                      --GROUP BY COUNT
--HAVING COUNT( FLOOR(DATEDIFF(DAY, Birth_Date, CURRENT_TIMESTAMP) / 365.25) )>=18
HAVING COUNT(*)>1

--avg price for an event with cf


SELECT E.name, AVG(C.Price)+3000 AS 'Average Event Price'FROM Enrolled En, Event E, Catering_Firma C  --GROUP BY AVG
WHERE E.id_event=En.id_event AND E.Name NOT IN ('Party', 'Baptism')                                     --NOT IN                                     
GROUP BY E.Name


SELECT Name, MIN(Max_People) AS 'smallest event room' FROM Event                        
WHERE id_event = ALL(SELECT id_event FROM Enrolled En WHERE En.id_event<7)             --geschachtelt
GROUP BY Name                                                                             --GROUP BY COUNT MIN
HAVING COUNT(*)>0
ORDER BY Name                                                                             --ORDER BY



