SELECT DISTINCT hotel.*
FROM hotel, room, roomrate, hotelfacilities 
WHERE hotel.stars = '4' AND  left(hotel."name", 1)='M'
AND room.roomtype = 'Studio' AND hotel."idHotel" = room."idHotel" 
AND hotel."idHotel" = roomrate."idHotel" AND hotel."idHotel" = hotelfacilities."idHotel" 
AND roomrate.rate - ( (roomrate.discount * roomrate.rate) /100) < 80
AND hotelfacilities."nameFacility" = 'Breakfast' 
AND hotelfacilities."nameFacility" = 'Restaurant'

SELECT DISTINCT hotel."idHotel", hotel."name" 
FROM hotel
WHERE  hotel.stars = '4' AND  left(hotel."name", 1)='M'
AND room.roomtype = 'Studio' AND hotel."idHotel" = room."idHotel" 
AND hotel."idHotel" = roomrate."idHotel" AND hotel."idHotel" = hotelfacilities."idHotel" 
AND roomrate.rate - ( (roomrate.discount * roomrate.rate) /100) < 80
AND hotelfacilities."nameFacility" = 'Breakfast' 
AND hotelfacilities."nameFacility" = 'Restaurant'

SELECT DISTINCT hotel."idHotel", hotel."name"
FROM hotel
INNER JOIN hotelfacilities ON hotel."idHotel" = hotelfacilities."idHotel"
WHERE hotelfacilities."nameFacility" = 'Breakfast'
ORDER BY "idHotel" ASC;
hotelfacilities."nameFacility" = 'Restaurant'

SELECT * 
FROM hotelfacilities WHERE hotelfacilities."idHotel" = '50'


SELECT *
FROM roomrate 
WHERE roomrate."idHotel" = '28' OR roomrate."idHotel" = '107' OR roomrate."idHotel" = '104'
OR roomrate."idHotel" = '79' OR roomrate."idHotel" = '108'

SELECT DISTINCT hotel.*
FROM hotel
INNER JOIN room ON hotel."idHotel" = room."idHotel"
INNER JOIN roomrate ON hotel."idHotel" = roomrate."idHotel" AND roomrate.roomtype = 'Studio' 
					AND roomrate.rate - ( (roomrate.discount * roomrate.rate) /100) < 80
INNER JOIN hotelfacilities ON hotel."idHotel" = hotelfacilities."idHotel" AND 
(SELECT count(1) = 2 FROM hotelfacilities WHERE ( hotelfacilities."idHotel" = hotel."idHotel" AND 
												 (hotelfacilities."nameFacility" = 'Breakfast' 
												 OR hotelfacilities."nameFacility" = 'Restaurant')))		
WHERE hotel.stars = '4' AND  left(hotel."name", 1)='B'


SELECT DISTINCT hotel.*
FROM hotel
INNER JOIN hotelfacilities ON hotel."idHotel" = hotelfacilities."idHotel"
SELECT * FROM hotelfacilities WHERE  hotelfacilities."idHotel" = '54' 

SELECT DISTINCT roomrate."idHotel", roomrate.rate, roomrate.discount FROM roomrate WHERE roomrate.rate - ( (roomrate.discount * roomrate.rate) /100) < 80

SELECT hotel."idHotel", hotel."name", roomrate.roomtype
FROM hotel
INNER JOIN roomrate ON hotel."idHotel" = roomrate."idHotel" 
WHERE roomrate.discount = (SELECT MAX(roomrate.discount) FROM roomrate)
ORDER BY roomrate.roomtype ASC;

SELECT *
FROM roomrate
WHERE roomrate."idHotel" = '11'


SELECT DISTINCT roombooking."hotelbookingID", person.fname, person.lname, 
hotelbooking.reservationdate,
CASE 
	WHEN EXISTS (SELECT 1 FROM employee WHERE employee."idEmployee" = hotelbooking."bookedbyclientID" LIMIT 1) THEN
		'employee'
	WHEN NOT EXISTS (SELECT 1 FROM employee WHERE employee."idEmployee" = hotelbooking."bookedbyclientID" LIMIT 1) THEN
		'client'
END bookedBy
FROM room
INNER JOIN roombooking ON room."idHotel" = '89'
INNER JOIN hotelbooking ON roombooking."hotelbookingID" = hotelbooking.idhotelbooking
INNER JOIN person ON hotelbooking."bookedbyclientID" = person."idPerson"

SELECT EXISTS (SELECT 1 FROM client WHERE client."idClient" = '10' LIMIT 1);



INNER JOIN roombooking ON hotel."idHotel" = roombooking.
