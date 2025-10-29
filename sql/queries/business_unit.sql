-- name: CreateBusinessUnit :one
INSERT INTO business_units (id, name, description, created_at, updated_at)
VALUES (
    $1, 
    $2,
    $3,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetBusinessUnitByID :one
SELECT * FROM business_units 
WHERE id = $1; 

-- name: GetBusinessUnitByName :one
SELECT * FROM business_units 
WHERE name = $1;

-- name: UpsertBusinessUnit :one
INSERT INTO business_units (id, name, description, created_at, updated_at)
VALUES (
    $1, 
    $2,
    $3,
    NOW(),
    NOW()
)
ON CONFLICT (id) DO NOTHING
RETURNING *;

-- name: ListBusinessUnits :many
SELECT * FROM business_units 
ORDER BY name;