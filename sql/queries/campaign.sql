-- =====================================================
-- CAMPAIGN QUERIES
-- =====================================================

-- name: CreateCampaignCategory :one
INSERT INTO campaign_category (category_name)
VALUES ($1)
RETURNING *;

-- name: GetCampaignCategoryByName :one
SELECT * FROM campaign_category WHERE category_name = $1;

-- name: UpsertCampaignCategory :one
INSERT INTO campaign_category (category_name)
VALUES ($1)
ON CONFLICT (category_name) DO NOTHING
RETURNING *;

-- name: CreateCampaign :one
INSERT INTO campaign (campaign_name, campaign_category_id, campaign_type, phone_number)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetCampaignByID :one
SELECT * FROM campaign WHERE campaign_id = $1;

-- name: GetCampaignByName :one
SELECT * FROM campaign WHERE campaign_name = $1;

-- name: UpsertCampaign :one
INSERT INTO campaign (campaign_name, campaign_category_id, campaign_type, phone_number)
VALUES ($1, $2, $3, $4)
ON CONFLICT DO NOTHING
RETURNING *;