USE EventPlanning;
GO

--1
ALTER PROCEDURE einfuegen(@id_catering_firma int, @id_event int ,@date_catering date, @stars int)
AS

	DECLARE @check1 bit, @check2 bit
	exec @check1 = dbo.check_date @date_catering
	exec @check2 = dbo.check_stars @stars

	if(@check1 = 1 AND @check2 = 1)
		INSERT INTO Enrolled (id_event, id_catering, startdate_Catering_Prepares_for_Event, star) VALUES (@id_event, @id_catering_firma, @date_catering, @stars)
	else
		if(@check1=0 AND @check2=1)
			print 'Start date of catering for preparing the event entered is not valid'
		else
			if(@check1=1 AND @check2=0)
				print 'stars entered are invalid'
			else
				print 'Start date of catering for preparing the event and the stars entered is not valid'
GO

CREATE FUNCTION check_date (@date_catering date)
RETURNS bit AS
BEGIN
	DECLARE @found bit
	if(@date_catering<GETDATE())
		SET @found = 0
	else
		SET @found = 1

RETURN @found

END
GO

CREATE FUNCTION check_stars (@stars int)
RETURNS bit AS
BEGIN
	DECLARE @found bit
	if(@stars<0 OR @stars>5)
		SET @found = 0
	else
		SET @found = 1

RETURN @found

END
GO

exec einfuegen 2,2,'2021-01-27',3-- id_cateringFirma, id_event  2 2

SELECT * FROM Enrolled

--2
CREATE OR ALTER VIEW view1 AS
SELECT EP.Name AS 'EventPlanner', EP.Telefon, E.Name AS 'Event', E.Date, E.location
FROM Event_Planner EP, Event E
WHERE E.Planner_id=EP.id_planner

GO
CREATE OR ALTER FUNCTION getTable (@City varchar(20))
RETURNS TABLE
AS
	RETURN
		SELECT *
		FROM Location L
		WHERE L.city=@City
GO
SELECT * FROM dbo.getTable('Washington')

SELECT * FROM view1
INNER JOIN dbo.getTable('Washington') table2
ON table2.location_id=view1.location

DECLARE @name_catering varchar(20) 
DECLARE @typ_catering varchar(20) 
DECLARE @id_catering int
DECLARE @price_catering float
DECLARE cursor_catering CURSOR FOR
SELECT C.id_catering, C.Typ FROM Catering_Firma C
FOR UPDATE of C.Price
OPEN cursor_catering
FETCH NEXT FROM cursor_catering INTO @id_catering, @typ_catering
WHILE @@FETCH_STATUS=0
BEGIN
	
	EXEC lab4_procedura @id_catering, @typ_catering
	FETCH NEXT FROM cursor_catering INTO @id_catering, @typ_catering
END
CLOSE cursor_catering
DEALLOCATE cursor_catering
GO

SELECT * FROM Catering_Firma
go

ALTER PROCEDURE lab4_procedura(@id_catering int, @typ_catering varchar(20))
AS
	BEGIN
		if @typ_catering = 'Food'
			UPDATE Catering_Firma SET Price=Price+0.1*Price WHERE @id_catering=id_catering
		else
			if @typ_catering = 'Decoration'
				UPDATE Catering_Firma SET Price=Price-0.15*Price WHERE id_catering=@id_catering
			else
				if @typ_catering = 'FlowerShop'
				UPDATE Catering_Firma SET Price=Price+0.20*Price WHERE id_catering=@id_catering
					
		SELECT * FROM Catering_Firma C
		INNER JOIN Enrolled E
		ON E.id_catering=C.id_catering
		INNER JOIN Event Ev
		ON Ev.id_event=E.id_event
		WHERE C.id_catering=@id_catering
	END
GO

ALTER TRIGGER lab4_trigger
ON Location
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @operation varchar(1)
	DECLARE @affected_rows INT

	SET @affected_rows=@@ROWCOUNT
	if exists(SELECT * FROM inserted) AND exists(SELECT * FROM deleted)
		SET @operation = 'U'
	else
		if exists(SELECT * FROM deleted)
			SET @operation = 'D'
		else
			if exists(SELECT * FROM inserted)
			begin
				SET @operation = 'I'
			end
	INSERT INTO Logtabelle(date_time,typ_anweisung,name_tabelle,anzahl) VALUES (GETDATE(),@operation,'Location',@affected_rows)
		
END
GO

INSERT INTO Location(city, street, location_id, number) VALUES ('Washington', 'Arhives', 5, 5), ('Chicago','Barrys Street',6,9)
DELETE FROM Location WHERE location_id=5 or location_id=6
UPDATE Location SET number=6 WHERE number=5 or number=7

SELECT * FROM Location
SELECT * FROM Logtabelle

CREATE TABLE Logtabelle(
date_time datetime,
typ_anweisung varchar(50),
name_tabelle varchar(20),
anzahl int)
DROP TABLE Logtabelle

