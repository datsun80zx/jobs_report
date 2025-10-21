-- =====================================================
-- JOB QUERIES
-- =====================================================

-- name: CreateJob :one
INSERT INTO job (
    job_id, job_type_id, business_unit_id, customer_id, location_id,
    project_id, job_campaign_id, call_campaign_id, job_status, priority,
    summary, job_creation_date, job_schedule_date, job_completion_date,
    scheduled_time, first_dispatch_date, hold_date, start_of_work_time,
    end_of_work_time, booked_by_user_id, dispatched_by_user_id,
    sold_by_technician_id, is_warranty, warranty_for_job_id,
    is_recall, recall_for_job_id
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
    $11, $12, $13, $14, $15, $16, $17, $18,
    $19, $20, $21, $22, $23, $24, $25, $26
)
RETURNING *;

-- name: GetJobByID :one
SELECT * FROM job WHERE job_id = $1;

-- name: UpsertJob :one
INSERT INTO job (
    job_id, job_type_id, business_unit_id, customer_id, location_id,
    project_id, job_campaign_id, call_campaign_id, job_status, priority,
    summary, job_creation_date, job_schedule_date, job_completion_date,
    scheduled_time, first_dispatch_date, hold_date, start_of_work_time,
    end_of_work_time, booked_by_user_id, dispatched_by_user_id,
    sold_by_technician_id, is_warranty, warranty_for_job_id,
    is_recall, recall_for_job_id
)
VALUES (
    $1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
    $11, $12, $13, $14, $15, $16, $17, $18,
    $19, $20, $21, $22, $23, $24, $25, $26
)
ON CONFLICT (job_id)
DO UPDATE SET
    job_type_id = EXCLUDED.job_type_id,
    business_unit_id = EXCLUDED.business_unit_id,
    customer_id = EXCLUDED.customer_id,
    location_id = EXCLUDED.location_id,
    project_id = EXCLUDED.project_id,
    job_campaign_id = EXCLUDED.job_campaign_id,
    call_campaign_id = EXCLUDED.call_campaign_id,
    job_status = EXCLUDED.job_status,
    priority = EXCLUDED.priority,
    summary = EXCLUDED.summary,
    job_creation_date = EXCLUDED.job_creation_date,
    job_schedule_date = EXCLUDED.job_schedule_date,
    job_completion_date = EXCLUDED.job_completion_date,
    scheduled_time = EXCLUDED.scheduled_time,
    first_dispatch_date = EXCLUDED.first_dispatch_date,
    hold_date = EXCLUDED.hold_date,
    start_of_work_time = EXCLUDED.start_of_work_time,
    end_of_work_time = EXCLUDED.end_of_work_time,
    booked_by_user_id = EXCLUDED.booked_by_user_id,
    dispatched_by_user_id = EXCLUDED.dispatched_by_user_id,
    sold_by_technician_id = EXCLUDED.sold_by_technician_id,
    is_warranty = EXCLUDED.is_warranty,
    warranty_for_job_id = EXCLUDED.warranty_for_job_id,
    is_recall = EXCLUDED.is_recall,
    recall_for_job_id = EXCLUDED.recall_for_job_id
RETURNING *;

-- name: ListJobsByStatus :many
SELECT * FROM job 
WHERE job_status = $1
ORDER BY job_creation_date DESC
LIMIT $2 OFFSET $3;

-- name: ListJobsByCustomerID :many
SELECT * FROM job 
WHERE customer_id = $1
ORDER BY job_creation_date DESC;

-- name: ListJobsByDateRange :many
SELECT * FROM job
WHERE job_creation_date BETWEEN $1 AND $2
ORDER BY job_creation_date DESC
LIMIT $3 OFFSET $4;

-- name: UpdateJobStatus :exec
UPDATE job 
SET job_status = $2, job_completion_date = $3
WHERE job_id = $1;

-- =====================================================
-- JOB TYPE QUERIES
-- =====================================================

-- name: CreateJobType :one
INSERT INTO job_type (job_type_name, sold_threshold)
VALUES ($1, $2)
RETURNING *;

-- name: GetJobTypeByID :one
SELECT * FROM job_type WHERE job_type_id = $1;

-- name: GetJobTypeByName :one
SELECT * FROM job_type WHERE job_type_name = $1;

-- name: UpsertJobType :one
INSERT INTO job_type (job_type_name, sold_threshold)
VALUES ($1, $2)
ON CONFLICT (job_type_name) 
DO UPDATE SET sold_threshold = EXCLUDED.sold_threshold
RETURNING *;

-- name: ListJobTypes :many
SELECT * FROM job_type ORDER BY job_type_name;

-- =====================================================
-- JOB TECHNICIAN QUERIES
-- =====================================================

-- name: CreateJobTechnician :one
INSERT INTO job_technician (job_id, technician_id, split_percentage, assignment_order, hours_worked)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetJobTechniciansByJobID :many
SELECT 
    jt.*,
    t.technician_name,
    t.email
FROM job_technician jt
JOIN technician t ON jt.technician_id = t.technician_id
WHERE jt.job_id = $1
ORDER BY jt.assignment_order;

-- name: UpsertJobTechnician :one
INSERT INTO job_technician (job_id, technician_id, split_percentage, assignment_order, hours_worked)
VALUES ($1, $2, $3, $4, $5)
ON CONFLICT (job_id, technician_id)
DO UPDATE SET
    split_percentage = EXCLUDED.split_percentage,
    assignment_order = EXCLUDED.assignment_order,
    hours_worked = EXCLUDED.hours_worked
RETURNING *;

-- name: DeleteJobTechnicians :exec
DELETE FROM job_technician WHERE job_id = $1;