-- =====================================================
-- BUSINESS UNIT QUERIES
-- =====================================================

-- name: CreateBusinessUnit :one
INSERT INTO business_unit (business_unit_name)
VALUES ($1)
RETURNING *;

-- name: GetBusinessUnitByID :one
SELECT * FROM business_unit WHERE business_unit_id = $1;

-- name: GetBusinessUnitByName :one
SELECT * FROM business_unit WHERE business_unit_name = $1;

-- name: UpsertBusinessUnit :one
INSERT INTO business_unit (business_unit_name)
VALUES ($1)
ON CONFLICT (business_unit_name) DO NOTHING
RETURNING *;

-- name: ListBusinessUnits :many
SELECT * FROM business_unit ORDER BY business_unit_name;