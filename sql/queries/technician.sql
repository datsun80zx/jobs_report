-- =====================================================
-- TECHNICIAN QUERIES
-- =====================================================

-- name: CreateTechnician :one
INSERT INTO technician (technician_name, business_unit_id, email)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetTechnicianByID :one
SELECT * FROM technician WHERE technician_id = $1;

-- name: GetTechnicianByName :one
SELECT * FROM technician WHERE technician_name = $1;

-- name: ListTechnicians :many
SELECT * FROM technician ORDER BY technician_name;

-- name: UpsertTechnician :one
INSERT INTO technician (technician_name, business_unit_id, email)
VALUES ($1, $2, $3)
ON CONFLICT DO NOTHING
RETURNING *;