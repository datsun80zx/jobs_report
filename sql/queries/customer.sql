-- name: CreateCustomer :one
INSERT INTO customers (id, name, city, state, zip, customer_type,created_at, updated_at)
VALUES (
    $1, 
    $2, 
    $3, 
    $4, 
    $5, 
    $6,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetCustomerByID :one
SELECT * FROM customers 
WHERE id = $1;

-- name: UpsertCustomer :one
INSERT INTO customers (id, name, city, state, zip, customer_type,created_at, updated_at)
VALUES ($1, $2, $3, $4, $5, $6, NOW(),NOW())
ON CONFLICT (id) DO NOTHING
RETURNING *;

-- name: ListCustomers :many
SELECT * FROM customers ORDER BY name LIMIT $1 OFFSET $2;

-- name: SearchCustomersByName :many
SELECT * FROM customers
WHERE name ILIKE '%' || $1 || '%'
ORDER BY name
LIMIT $2;