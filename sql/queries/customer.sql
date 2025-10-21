-- =====================================================
-- CUSTOMER QUERIES
-- =====================================================

-- name: CreateCustomer :one
INSERT INTO customer (customer_id, customer_name, customer_type, city, state, zip_code)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: GetCustomerByID :one
SELECT * FROM customer WHERE customer_id = $1;

-- name: UpsertCustomer :one
INSERT INTO customer (customer_id, customer_name, customer_type, city, state, zip_code)
VALUES ($1, $2, $3, $4, $5, $6)
ON CONFLICT (customer_id) 
DO UPDATE SET 
    customer_name = EXCLUDED.customer_name,
    customer_type = EXCLUDED.customer_type,
    city = EXCLUDED.city,
    state = EXCLUDED.state,
    zip_code = EXCLUDED.zip_code
RETURNING *;

-- name: ListCustomers :many
SELECT * FROM customer ORDER BY customer_name LIMIT $1 OFFSET $2;

-- name: SearchCustomersByName :many
SELECT * FROM customer 
WHERE customer_name ILIKE '%' || $1 || '%'
ORDER BY customer_name
LIMIT $2;