-- =====================================================
-- USER QUERIES
-- =====================================================

-- name: CreateUser :one
INSERT INTO app_user (user_name, email)
VALUES ($1, $2)
RETURNING *;

-- name: GetUserByID :one
SELECT * FROM app_user WHERE user_id = $1;

-- name: GetUserByName :one
SELECT * FROM app_user WHERE user_name = $1;

-- name: UpsertUser :one
INSERT INTO app_user (user_name, email)
VALUES ($1, $2)
ON CONFLICT (user_name) 
DO UPDATE SET email = EXCLUDED.email
RETURNING *;