-- name: CreateJobCampaign :one
INSERT INTO job_campaigns (id, name, description, created_at, updated_at)
VALUES (
    $1, 
    $2,
    $3,
    NOW(),
    NOW()
)
RETURNING *;

-- name: GetOneJobCampaign :one
SELECT * FROM job_campaigns
WHERE job_campaigns.id = $1;

-- name: ListJobCampaigns :many
SELECT * FROM job_campaigns
ORDER BY job_campaigns.name;