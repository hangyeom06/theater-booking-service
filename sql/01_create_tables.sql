CREATE TABLE account (
    account_id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL
        CHECK (role IN ('AUDIENCE', 'ORGANIZATION')),
    display_name VARCHAR(100) NOT NULL
);
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE venue (
    venue_id SERIAL PRIMARY KEY,
    venue_name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL
);
CREATE TABLE work (
    work_id SERIAL PRIMARY KEY,
    organization_account_id INTEGER NOT NULL
        REFERENCES account(account_id),
    category_id INTEGER NOT NULL
        REFERENCES category(category_id),
    title VARCHAR(150) NOT NULL,
    description TEXT
);
CREATE TABLE seat (
    seat_id SERIAL PRIMARY KEY,
    venue_id INTEGER NOT NULL
        REFERENCES venue(venue_id),
    section_name VARCHAR(1) NOT NULL
        CHECK (section_name IN ('A', 'B', 'C')),
    row_label VARCHAR(10) NOT NULL,
    seat_number INTEGER NOT NULL
        CHECK (seat_number > 0),
    grade VARCHAR(20) NOT NULL,
    UNIQUE (venue_id, section_name, row_label, seat_number)
);
CREATE TABLE performance (
    performance_id SERIAL PRIMARY KEY,
    work_id INTEGER NOT NULL
        REFERENCES work(work_id),
    venue_id INTEGER NOT NULL
        REFERENCES venue(venue_id),
    starts_at TIMESTAMP NOT NULL,
    ends_at TIMESTAMP NOT NULL,
    CHECK (ends_at > starts_at)
);
CREATE TABLE ticket_type (
    ticket_type_id SERIAL PRIMARY KEY,
    performance_id INTEGER NOT NULL
        REFERENCES performance(performance_id),
    section_name VARCHAR(1) NOT NULL
        CHECK (section_name IN ('A', 'B', 'C')),
    seat_grade VARCHAR(20) NOT NULL,
    price INTEGER NOT NULL
        CHECK (price >= 0),
    UNIQUE (performance_id, section_name, seat_grade)
);
CREATE TABLE reservation (
    reservation_id SERIAL PRIMARY KEY,
    audience_account_id INTEGER NOT NULL
        REFERENCES account(account_id),
    performance_id INTEGER NOT NULL
        REFERENCES performance(performance_id),
    reserved_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE ticket (
    ticket_id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL
        REFERENCES reservation(reservation_id),
    seat_id INTEGER NOT NULL
        REFERENCES seat(seat_id),
    ticket_type_id INTEGER NOT NULL
        REFERENCES ticket_type(ticket_type_id),
    price_at_booking INTEGER NOT NULL
        CHECK (price_at_booking >= 0),
    ticket_status VARCHAR(20) NOT NULL DEFAULT 'BOOKED'
        CHECK (ticket_status IN ('BOOKED', 'CANCELED', 'ENTERED')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'UNPAID'
        CHECK (payment_status IN ('UNPAID', 'PAID', 'REFUNDED'))
);
CREATE UNIQUE INDEX uq_active_ticket_seat
ON ticket (ticket_type_id, seat_id)
WHERE ticket_status <> 'CANCELED';
CREATE TABLE payment_history (
    payment_history_id SERIAL PRIMARY KEY,
    ticket_id INTEGER NOT NULL
        REFERENCES ticket(ticket_id),
    history_type VARCHAR(20) NOT NULL
        CHECK (history_type IN ('PAYMENT', 'REFUND')),
    amount INTEGER NOT NULL
        CHECK (amount >= 0),
    processed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE review (
    review_id SERIAL PRIMARY KEY,
    audience_account_id INTEGER NOT NULL
        REFERENCES account(account_id),
    performance_id INTEGER NOT NULL
        REFERENCES performance(performance_id),
    rating INTEGER NOT NULL
        CHECK (rating BETWEEN 1 AND 5),
    review_content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (audience_account_id, performance_id)
);
