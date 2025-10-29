-- name: CreateOpportunity :one
INSERT INTO opportunities (id, created_at, updated_at, business_units_id, job_types_id, technicians_id, jobs_id)
VALUES (
    $1, 
    NOW(),
    NOW(), 
    $2, 
    $3,
    $4,
    $5
)
RETURNING *;

-- name: GetOneOpportunity :one
SELECT * FROM opportunities
WHERE id == $1;

-- name: ListOpportunitiesByBusinessUnit :many
SELECT * FROM opportunities 
WHERE business_units_id = $1;

-- name: ListOpportunitiesByJobTypes :many
SELECT * FROM opportunities 
WHERE job_types_id = $1;

-- name: ListOpportunitiesByTech :many
SELECT * FROM opportunities
WHERE technicians_id = $1;