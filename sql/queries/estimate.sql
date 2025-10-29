-- name: CreateEstimate :one
INSERT INTO estimates (id, name, description, subtotal, is_sold, invoices_id, opportunities_id, jobs_id, sold_on_date, created_at, updated_at)
VALUES (
    $1, 
    $2,
    $3,
    $4,
    $5,
    $6,
    $7,
    $8,
    $9,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetEstimateByID :one
SELECT * FROM estimates WHERE id = $1;

-- name: GetEstimatesByJobID :many
SELECT * FROM estimates WHERE jobs_id = $1 ORDER BY created_at;

-- name: UpdateEstimateSold :exec
UPDATE estimates
SET is_sold = $2, sold_on_date = $3
WHERE id = $1;