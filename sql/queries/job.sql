-- name: CreateJob :one
INSERT INTO jobs (
    id, job_type_id, business_unit_id, customer_id, location_id, project_id, job_campaign_id, call_campaign_id, job_status, job_priority, job_summary, job_creation_date, 
    job_schedule_date, job_completion_date, assigned_tech_id, sold_tech_id, sold_bu_id, count_of_estimates, sold_estimate_id, campaign_category_id, invoice_id, opportunity_id,
    is_warranty, warranty_of_job_id, is_recall, recall_of_job_id, is_converted, survey_score, dispatched_by_user_id, booked_by_user_id, job_id_of_created_lead, is_zero_cost,
    scheduled_time, first_dispatch, hold_date, sold_date, start_time, end_time, primary_tech_id, first_response_time)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
    $11, $12, $13, $14, $15, $16, $17, $18,
    $19, $20, $21, $22, $23, $24, $25, $26, $27,
    $28, $29, $30, $31, $32, $33, $34, $35, $36, 
    $37, $38, $39, $40
)
RETURNING *;

-- name: GetJobByID :one
SELECT * FROM jobs WHERE id = $1;

-- name: UpsertJob :one
INSERT INTO jobs (
    id, job_type_id, business_unit_id, customer_id, location_id, project_id, job_campaign_id, call_campaign_id, job_status, job_priority, job_summary, job_creation_date, 
    job_schedule_date, job_completion_date, assigned_tech_id, sold_tech_id, sold_bu_id, count_of_estimates, sold_estimate_id, campaign_category_id, invoice_id, opportunity_id,
    is_warranty, warranty_of_job_id, is_recall, recall_of_job_id, is_converted, survey_score, dispatched_by_user_id, booked_by_user_id, job_id_of_created_lead, is_zero_cost,
    scheduled_time, first_dispatch, hold_date, sold_date, start_time, end_time, primary_tech_id, first_response_time
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
    $11, $12, $13, $14, $15, $16, $17, $18,
    $19, $20, $21, $22, $23, $24, $25, $26, $27,
    $28, $29, $30, $31, $32, $33, $34, $35, $36, 
    $37, $38, $39, $40
)
ON CONFLICT (id) DO NOTHING 
RETURNING *;

-- name: ListJobsByStatus :many
SELECT * FROM jobs 
WHERE job_status = $1
ORDER BY job_creation_date DESC
LIMIT $2 OFFSET $3;

-- name: ListJobsByCustomerID :many
SELECT * FROM jobs 
WHERE customer_id = $1
ORDER BY job_creation_date DESC;

-- name: ListJobsByDateRange :many
SELECT * FROM jobs
WHERE job_creation_date BETWEEN $1 AND $2
ORDER BY job_creation_date DESC
LIMIT $3 OFFSET $4;

-- name: UpdateJobStatus :exec
UPDATE jobs
SET job_status = $2, job_completion_date = $3
WHERE id = $1;

-- -- name: CreateJobType :one
-- INSERT INTO job_type (job_type_name, sold_threshold)
-- VALUES ($1, $2)
-- RETURNING *;

-- -- name: GetJobTypeByID :one
-- SELECT * FROM job_type WHERE job_type_id = $1;

-- -- name: GetJobTypeByName :one
-- SELECT * FROM job_type WHERE job_type_name = $1;

-- -- name: UpsertJobType :one
-- INSERT INTO job_type (job_type_name, sold_threshold)
-- VALUES ($1, $2)
-- ON CONFLICT (job_type_name) 
-- DO UPDATE SET sold_threshold = EXCLUDED.sold_threshold
-- RETURNING *;

-- -- name: ListJobTypes :many
-- SELECT * FROM job_type ORDER BY job_type_name;

-- -- =====================================================
-- -- JOB TECHNICIAN QUERIES
-- -- =====================================================

-- -- name: CreateJobTechnician :one
-- INSERT INTO job_technician (job_id, technician_id, split_percentage, assignment_order, hours_worked)
-- VALUES ($1, $2, $3, $4, $5)
-- RETURNING *;

-- -- name: GetJobTechniciansByJobID :many
-- SELECT 
--     jt.*,
--     t.technician_name,
--     t.email
-- FROM job_technician jt
-- JOIN technician t ON jt.technician_id = t.technician_id
-- WHERE jt.job_id = $1
-- ORDER BY jt.assignment_order;

-- -- name: UpsertJobTechnician :one
-- INSERT INTO job_technician (job_id, technician_id, split_percentage, assignment_order, hours_worked)
-- VALUES ($1, $2, $3, $4, $5)
-- ON CONFLICT (job_id, technician_id)
-- DO UPDATE SET
--     split_percentage = EXCLUDED.split_percentage,
--     assignment_order = EXCLUDED.assignment_order,
--     hours_worked = EXCLUDED.hours_worked
-- RETURNING *;

-- -- name: DeleteJobTechnicians :exec
-- DELETE FROM job_technician WHERE job_id = $1;