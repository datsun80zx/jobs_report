-- =====================================================
-- ESTIMATE QUERIES
-- =====================================================

-- name: CreateEstimate :one
INSERT INTO estimate (job_id, estimate_subtotal, is_sold, sold_on_date)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetEstimateByID :one
SELECT * FROM estimate WHERE estimate_id = $1;

-- name: GetEstimatesByJobID :many
SELECT * FROM estimate WHERE job_id = $1 ORDER BY created_at;

-- name: UpdateEstimateSold :exec
UPDATE estimate 
SET is_sold = $2, sold_on_date = $3
WHERE estimate_id = $1;