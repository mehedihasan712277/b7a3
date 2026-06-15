
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;


CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL
        CHECK (role IN ('Football Fan', 'Ticket Manager')),
    phone_number VARCHAR(20)
);

CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    fixture VARCHAR(100) NOT NULL,
    tournament_category VARCHAR(50) NOT NULL,
    base_ticket_price INT NOT NULL
        CHECK (base_ticket_price >= 0),
    match_status VARCHAR(20) NOT NULL
        CHECK (
            match_status IN (
                'Available',
                'Selling Fast',
                'Sold Out',
                'Postponed'
            )
        )
);


CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES Users(user_id),
    match_id INT NOT NULL REFERENCES Matches(match_id),
    seat_number VARCHAR(20),
    payment_status VARCHAR(20) 
        CHECK (
            payment_status IN (
                'Pending',
                'Confirmed',
                'Cancelled',
                'Refunded'
            )
        ),
    total_cost INT NOT NULL CHECK (total_cost >= 0)
);



INSERT INTO Users (
    user_id,
    full_name,
    email,
    role,
    phone_number
)
VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);


INSERT INTO Matches (
    match_id,
    fixture,
    tournament_category,
    base_ticket_price,
    match_status
)
VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80, 'Available');


INSERT INTO Bookings (
    booking_id,
    user_id,
    match_id,
    seat_number,
    payment_status,
    total_cost
)
VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150),
(502, 1, 102, 'B-04', 'Confirmed', 120),
(503, 2, 101, 'A-13', 'Confirmed', 150),
(504, 2, 101, NULL, NULL, 150),
(505, 3, 102, 'C-20', 'Pending', 120);


-- -------------------------------------------------- asked queries ----------------------------------------

-- 1.
select match_id,fixture, base_ticket_price from Matches
where tournament_category = 'Champions League' and match_status = 'Available'

-- 2.
select user_id, full_name, email from Users
where full_name LIKE 'Tanvir%' or full_name ILIKE '%Haque%'

-- 3.
select booking_id,user_id,match_id, COALESCE(payment_status, 'Action Required') as systematic_status from Bookings
where payment_status is NULL

-- 4.
select booking_id, full_name, fixture, total_cost from Bookings
inner join Users using(user_id)
inner join Matches using(match_id)

-- 5.
select user_id, full_name, booking_id from Users
left join Bookings using(user_id)

-- 6.
select booking_id, match_id, total_cost from Bookings
where total_cost > (select avg(total_cost) from Bookings)

-- 7.
select * from Matches
where base_ticket_price != (select max(base_ticket_price) from Matches)
order by base_ticket_price desc limit 2