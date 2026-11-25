-- 1. 예약, 관객, 공연, 좌석, 티켓 정보를 함께 확인
SELECT
    t.ticket_id,
    a.display_name,
    w.title,
    p.starts_at,
    s.section_name,
    s.row_label,
    s.seat_number,
    tt.seat_grade,
    t.price_at_booking,
    t.ticket_status,
    t.payment_status
FROM ticket t
JOIN reservation r ON r.reservation_id = t.reservation_id
JOIN account a ON a.account_id = r.audience_account_id
JOIN performance p ON p.performance_id = r.performance_id
JOIN work w ON w.work_id = p.work_id
JOIN seat s ON s.seat_id = t.seat_id
JOIN ticket_type tt ON tt.ticket_type_id = t.ticket_type_id
ORDER BY t.ticket_id;


-- 2. 결제·환불 기록 확인
SELECT
    t.ticket_id,
    t.ticket_status,
    t.payment_status,
    h.history_type,
    h.amount,
    h.processed_at
FROM ticket t
LEFT JOIN payment_history h ON h.ticket_id = t.ticket_id
ORDER BY t.ticket_id, h.history_type;


-- 3. 관객이 남긴 후기를 공연 회차와 함께 확인
SELECT
    a.display_name,
    w.title,
    p.starts_at,
    rv.rating,
    rv.review_content
FROM review rv
JOIN account a ON a.account_id = rv.audience_account_id
JOIN performance p ON p.performance_id = rv.performance_id
JOIN work w ON w.work_id = p.work_id
ORDER BY rv.created_at;
