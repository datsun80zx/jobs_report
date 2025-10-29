-- name: CreateUser :one
INSERT INTO users (id, name, email, phone_number, is_tech, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    $1,
    $2,
    $3,
    $4,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetUserByID :one
SELECT * FROM users
WHERE id = $1;

-- name: GetUserByName :one
SELECT * FROM users 
WHERE name = $1;

-- name: UpsertUser :one
INSERT INTO users (id, name, email, phone_number, is_tech, created_at, updated_at)
VALUES (
    gen_random_uuid(),
    $1,
    $2,
    $3,
    $4,
    NOW(),
    NOW()
)
ON CONFLICT (id)
DO UPDATE SET 
    updated_at = NOW()
RETURNING *;