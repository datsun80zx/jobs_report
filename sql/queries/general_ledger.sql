-- =====================================================
-- GENERAL LEDGER ACCOUNT QUERIES
-- =====================================================

-- name: CreateGLAccount :one
INSERT INTO general_ledger_account (account_code, account_name, account_type)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetGLAccountByID :one
SELECT * FROM general_ledger_account WHERE gl_account_id = $1;

-- name: GetGLAccountByCode :one
SELECT * FROM general_ledger_account WHERE account_code = $1;

-- name: UpsertGLAccount :one
INSERT INTO general_ledger_account (account_code, account_name, account_type)
VALUES ($1, $2, $3)
ON CONFLICT (account_code) 
DO UPDATE SET account_name = EXCLUDED.account_name, account_type = EXCLUDED.account_type
RETURNING *;
