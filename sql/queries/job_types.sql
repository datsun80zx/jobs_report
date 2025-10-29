-- name: CreateJobType :one
INSERT INTO job_types (id, name, description, business_unit_id, skills_id, created_at, updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    $5,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetOneJobType :one
SELECT * FROM job_types
WHERE job_types.id = $1;

-- name: ListJobTypesByBusinessUnit :many
SELECT * FROM job_types
WHERE job_types.business_unit_id = $1
ORDER BY name;

-- name: ListJobTypesByJobSkills :many
SELECT * FROM job_types
WHERE job_types.skills_id = $1
ORDER BY business_unit_id;