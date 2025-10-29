-- name: CreateProject :one
INSERT INTO projects (id, summary, created_at, updated_at)
VALUES (
    $1,
    $2,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetProjectByID :one
SELECT * FROM projects WHERE projects.id = $1;