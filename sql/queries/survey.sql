-- =====================================================
-- SURVEY QUERIES
-- =====================================================

-- name: CreateSurvey :one
INSERT INTO survey (job_id, survey_score, survey_date, comments)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetSurveyByJobID :one
SELECT * FROM survey WHERE job_id = $1;

-- name: UpsertSurvey :one
INSERT INTO survey (job_id, survey_score, survey_date, comments)
VALUES ($1, $2, $3, $4)
ON CONFLICT (job_id)
DO UPDATE SET
    survey_score = EXCLUDED.survey_score,
    survey_date = EXCLUDED.survey_date,
    comments = EXCLUDED.comments
RETURNING *;
