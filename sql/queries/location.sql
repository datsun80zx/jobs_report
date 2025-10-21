-- =====================================================
-- LOCATION QUERIES
-- =====================================================

-- name: CreateLocation :one
INSERT INTO location (customer_id, city, state, zip_code, street_address)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetLocationByID :one
SELECT * FROM location WHERE location_id = $1;

-- name: GetLocationsByCustomerID :many
SELECT * FROM location WHERE customer_id = $1;