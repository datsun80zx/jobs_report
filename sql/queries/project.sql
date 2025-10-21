-- =====================================================
-- PROJECT QUERIES
-- =====================================================

-- name: CreateProject :one
INSERT INTO project (project_name)
VALUES ($1)
RETURNING *;

-- name: GetProjectByID :one
SELECT * FROM project WHERE project_id = $1;