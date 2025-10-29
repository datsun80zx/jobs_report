-- name: CreateTechnician :one
INSERT INTO technicians (id, name, email, phone_number, created_at, updated_at)
VALUES (
    $1,
    $2,
    $3,
    $4,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetTechnicianByID :one
SELECT * FROM technicians WHERE technicians.id = $1;

-- name: GetTechnicianByName :one
SELECT * FROM technicians WHERE technicians.name = $1;

-- name: ListTechnicians :many
SELECT * FROM technicians ORDER BY name;

-- name: UpsertTechnician :one
INSERT INTO technicians (id, name, email, phone_number, created_at, updated_at)
VALUES ($1, $2, $3, $4, NOW(), NOw())
ON CONFLICT (id) DO NOTHING
RETURNING *;