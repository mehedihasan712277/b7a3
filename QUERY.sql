-- drop previous table

DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS users;

-- USERS TABLE
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) NOT NULL
        CHECK (role IN ('Football Fan', 'Ticket Manager')),
    phone_number VARCHAR(20)
);

-- MATCHES TABLE
CREATE TABLE matches (
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

-- BOOKINGS TABLE
CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    match_id INT NOT NULL REFERENCES matches(match_id),
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


-- INSERT USERS
INSERT INTO users (
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

-- INSERT MATCHES
INSERT INTO matches (
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

-- INSERT BOOKINGS
INSERT INTO bookings (
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
