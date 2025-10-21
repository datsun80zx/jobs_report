-- =====================================================
-- TAG QUERIES
-- =====================================================

-- name: CreateJobTag :one
INSERT INTO job_tag (tag_name)
VALUES ($1)
RETURNING *;

-- name: GetJobTagByName :one
SELECT * FROM job_tag WHERE tag_name = $1;

-- name: UpsertJobTag :one
INSERT INTO job_tag (tag_name)
VALUES ($1)
ON CONFLICT (tag_name) DO NOTHING
RETURNING *;

-- name: AssignJobTag :exec
INSERT INTO job_tag_assignment (job_id, job_tag_id)
VALUES ($1, $2)
ON CONFLICT DO NOTHING;

-- name: GetJobTagsByJobID :many
SELECT jt.* 
FROM job_tag jt
JOIN job_tag_assignment jta ON jt.job_tag_id = jta.job_tag_id
WHERE jta.job_id = $1;

-- name: CreateCustomerTag :one
INSERT INTO customer_tag (tag_name)
VALUES ($1)
RETURNING *;

-- name: GetCustomerTagByName :one
SELECT * FROM customer_tag WHERE tag_name = $1;

-- name: UpsertCustomerTag :one
INSERT INTO customer_tag (tag_name)
VALUES ($1)
ON CONFLICT (tag_name) DO NOTHING
RETURNING *;

-- name: AssignCustomerTag :exec
INSERT INTO customer_tag_assignment (customer_id, customer_tag_id)
VALUES ($1, $2)
ON CONFLICT DO NOTHING;

-- name: GetCustomerTagsByCustomerID :many
SELECT ct.* 
FROM customer_tag ct
JOIN customer_tag_assignment cta ON ct.customer_tag_id = cta.customer_tag_id
WHERE cta.customer_id = $1;

-- name: CreateLocationTag :one
INSERT INTO location_tag (tag_name)
VALUES ($1)
RETURNING *;

-- name: GetLocationTagByName :one
SELECT * FROM location_tag WHERE tag_name = $1;

-- name: UpsertLocationTag :one
INSERT INTO location_tag (tag_name)
VALUES ($1)
ON CONFLICT (tag_name) DO NOTHING
RETURNING *;

-- name: AssignLocationTag :exec
INSERT INTO location_tag_assignment (location_id, location_tag_id)
VALUES ($1, $2)
ON CONFLICT DO NOTHING;

-- name: GetLocationTagsByLocationID :many
SELECT lt.* 
FROM location_tag lt
JOIN location_tag_assignment lta ON lt.location_tag_id = lta.location_tag_id
WHERE lta.location_id = $1;