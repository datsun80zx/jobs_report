-- name: CreateInvoice :one
INSERT INTO invoices (id, customers_id, jobs_id, estimates_id, business_units_id, is_paid, created_at, updated_at)
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

-- name: GetInvoiceByID :one
SELECT * FROM invoices WHERE id = $1;

-- name: GetInvoiceByJobID :one
SELECT * FROM invoices WHERE jobs_id = $1;

-- name: UpsertInvoice :one
INSERT INTO invoices (id, customers_id, jobs_id, estimates_id, business_units_id, is_paid, created_at, updated_at)
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
ON CONFLICT (id) DO NOTHING
RETURNING *;

-- -- name: CreateInvoiceItem :one
-- INSERT INTO invoice_item (
--     invoice_id, gl_account_id, description, quantity,
--     unit_price, amount, tax_amount, item_order
-- )
-- VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
-- RETURNING *;

-- -- name: GetInvoiceItemsByInvoiceID :many
-- SELECT * FROM invoice_item 
-- WHERE invoice_id = $1
-- ORDER BY item_order;

-- -- name: DeleteInvoiceItems :exec
-- DELETE FROM invoice_item WHERE invoice_id = $1;