-- name: CreateLocation :one
INSERT INTO locations (id, name, city, state, zip, customer_id, created_at, updated_at)
VALUES (
    $1, 
    $2,
    $3,
    $4,
    $5,
    $6,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetLocationByID :one
SELECT * FROM locations WHERE locations.id = $1;

-- name: GetLocationsByCustomerID :many
SELECT * FROM locations WHERE locations.customer_id = $1;