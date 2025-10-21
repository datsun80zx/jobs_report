-- =====================================================
-- MEMBERSHIP QUERIES
-- =====================================================

-- name: CreateMembership :one
INSERT INTO membership (customer_id, membership_type, start_date, end_date, status)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetMembershipByID :one
SELECT * FROM membership WHERE membership_id = $1;

-- name: GetActiveMembershipByCustomerID :one
SELECT * FROM membership 
WHERE customer_id = $1 AND status = 'Active'
ORDER BY start_date DESC
LIMIT 1;

-- name: GetMembershipsByCustomerID :many
SELECT * FROM membership WHERE customer_id = $1 ORDER BY start_date DESC;

-- name: UpdateMembershipStatus :exec
UPDATE membership 
SET status = $2, end_date = $3
WHERE membership_id = $1;