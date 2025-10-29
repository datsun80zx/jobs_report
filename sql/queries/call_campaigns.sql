-- name: CreateCallCampaign :one
INSERT INTO call_campaigns (id, name, description, created_at, updated_at)
VALUES (
    $1, 
    $2,
    $3,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetOneCallCampaign :one
SELECT * FROM call_campaigns
WHERE id = $1;

-- name: ListCallCampaigns :many
SELECT * FROM call_campaigns
ORDER BY name;