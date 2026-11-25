-- 프로젝트 데이터베이스가 비어 있을 때 한 번만 실행
BEGIN;

INSERT INTO account (email, password_hash, role, display_name) VALUES
('company@example.com', 'sample_hash', 'ORGANIZATION', '별무리 극단'),
('audience@example.com', 'sample_hash', 'AUDIENCE', '김관객');

INSERT INTO category (category_name)
VALUES ('연극');

INSERT INTO venue (venue_name, address)
VALUES ('소극장 봄', '서울특별시 종로구');

INSERT INTO work (
    organization_account_id, category_id, title, description
) VALUES (
    1, 1, '별이 내리는 밤', '예시 공연 작품입니다.'
);

INSERT INTO seat (
    venue_id, section_name, row_label, seat_number, grade
) VALUES
(1, 'A', '1열', 1, 'VIP'),
(1, 'B', '1열', 1, 'R'),
(1, 'C', '1열', 1, 'R');

INSERT INTO performance (work_id, venue_id, starts_at, ends_at) VALUES
(1, 1, '2026-11-20 14:00', '2026-11-20 16:00'),
(1, 1, '2026-12-01 19:00', '2026-12-01 21:00');

INSERT INTO ticket_type (
    performance_id, section_name, seat_grade, price
) VALUES
(1, 'A', 'VIP', 90000),
(1, 'B', 'R',   70000),
(1, 'C', 'R',   70000),
(2, 'A', 'VIP', 90000),
(2, 'B', 'R',   70000),
(2, 'C', 'R',   70000);

INSERT INTO reservation (audience_account_id, performance_id) VALUES
(2, 1),
(2, 2),
(2, 2);

INSERT INTO ticket (
    reservation_id, seat_id, ticket_type_id, price_at_booking,
    ticket_status, payment_status
) VALUES
(1, 1, 1, 90000, 'ENTERED',  'PAID'),
(2, 1, 4, 90000, 'BOOKED',   'PAID'),
(2, 2, 5, 70000, 'CANCELED', 'REFUNDED'),
(3, 2, 5, 70000, 'BOOKED',   'UNPAID');

INSERT INTO payment_history (ticket_id, history_type, amount) VALUES
(1, 'PAYMENT', 90000),
(2, 'PAYMENT', 90000),
(3, 'PAYMENT', 70000),
(3, 'REFUND',  70000);

INSERT INTO review (
    audience_account_id, performance_id, rating, review_content
) VALUES (
    2, 1, 5, '공연이 인상적이었습니다.'
);

COMMIT;
