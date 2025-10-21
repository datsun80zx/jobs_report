-- =====================================================
-- INVOICE QUERIES
-- =====================================================

-- name: CreateInvoice :one
INSERT INTO invoice (invoice_id, job_id, invoice_date)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetInvoiceByID :one
SELECT * FROM invoice WHERE invoice_id = $1;

-- name: GetInvoiceByJobID :one
SELECT * FROM invoice WHERE job_id = $1;

-- name: UpsertInvoice :one
INSERT INTO invoice (invoice_id, job_id, invoice_date)
VALUES ($1, $2, $3)
ON CONFLICT (invoice_id)
DO UPDATE SET
    job_id = EXCLUDED.job_id,
    invoice_date = EXCLUDED.invoice_date
RETURNING *;

-- =====================================================
-- INVOICE ITEM QUERIES
-- =====================================================

-- name: CreateInvoiceItem :one
INSERT INTO invoice_item (
    invoice_id, gl_account_id, description, quantity,
    unit_price, amount, tax_amount, item_order
)
VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
RETURNING *;

-- name: GetInvoiceItemsByInvoiceID :many
SELECT * FROM invoice_item 
WHERE invoice_id = $1
ORDER BY item_order;

-- name: DeleteInvoiceItems :exec
DELETE FROM invoice_item WHERE invoice_id = $1;