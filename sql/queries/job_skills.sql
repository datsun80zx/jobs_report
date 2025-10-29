-- name: CreateJobSkills :one
INSERT INTO job_skills (id, name, description, business_unit_id, created_at, updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetOneJobSkills :one
SELECT * FROM job_skills
WHERE job_skills.id = $1;

-- name: ListJobSkilsByBusinessUnit :many
SELECT * FROM job_skills
WHERE 
    job_skills.business_unit_id = $1
ORDER BY job_skills.name;