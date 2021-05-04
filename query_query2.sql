SELECT hotel."idHotel", roomrate.rate, roomrate.discount, hotel.city
FROM hotel
INNER JOIN roomrate ON roomrate."idHotel" = hotel."idHotel"

SELECT DISTINCT ON (hotel."idHotel") hotel."idHotel",
hotel.city, rr.sum															
FROM hotel
INNER JOIN
(SELECT roomrate."idHotel", SUM(roomrate.rate - roomrate.rate*roomrate.discount*0.01)
FROM roomrate
GROUP BY roomrate."idHotel") AS rr ON rr."idHotel" = hotel."idHotel"
WHERE rr.sum > '700.875'
GROUP BY hotel."idHotel", rr.sum


SELECT AVG(rr.sum)
FROM (SELECT roomrate."idHotel", SUM(roomrate.rate - roomrate.rate*roomrate.discount*0.01)
FROM roomrate
GROUP BY roomrate."idHotel") AS rr


SELECT count(*) room
FROM (SELECT * FROM hotel WHERE hotel."idHotel" = '11') AS hotels
INNER JOIN room ON hotels."idHotel" = room."idHotel";

SELECT bookings.*
FROM (SELECT * FROM hotel WHERE hotel."idHotel" = '11') AS hotels
INNER JOIN room ON hotels."idHotel" = room."idHotel"
INNER JOIN (SELECT EXTRACT(month FROM (DATE_TRUNC('month',roombooking.checkin))),count(roombooking."roomID")
			FROM roombooking 
			WHERE
			(EXTRACT(year FROM roombooking.checkin) =2021 OR
			EXTRACT(year FROM roombooking.checkout) = 2021)
			GROUP BY EXTRACT(month FROM (DATE_TRUNC('month',roombooking.checkin)))
		   ) AS bookings
	ON bookings."roomID" = room."idRoom" 

SELECT EXTRACT(month FROM (DATE_TRUNC('month',roombooking.checkin))),count(roombooking."roomID")
FROM roombooking 
WHERE
(EXTRACT(year FROM roombooking.checkin) =2021 OR
EXTRACT(year FROM roombooking.checkout) = 2021)
GROUP BY EXTRACT(month FROM (DATE_TRUNC('month',roombooking.checkin)))