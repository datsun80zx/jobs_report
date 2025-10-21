-- =====================================================
-- ANALYTICAL QUERIES
-- =====================================================

-- name: GetJobFinancialSummary :one
SELECT * FROM vw_job_financial_summary WHERE job_id = $1;

-- name: GetJobWithFinancials :one
SELECT 
    j.*,
    jfs.job_subtotal,
    jfs.job_total,
    jfs.revenue,
    jfs.is_zero_dollar_job
FROM job j
LEFT JOIN vw_job_financial_summary jfs ON j.job_id = jfs.job_id
WHERE j.job_id = $1;

-- name: GetJobsWithFinancials :many
SELECT 
    j.*,
    jfs.job_subtotal,
    jfs.job_total,
    jfs.revenue,
    jfs.is_zero_dollar_job
FROM job j
LEFT JOIN vw_job_financial_summary jfs ON j.job_id = jfs.job_id
WHERE j.job_status = $1
ORDER BY j.job_creation_date DESC
LIMIT $2 OFFSET $3;

-- name: GetCustomerLifetimeValue :one
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT j.job_id) as total_jobs,
    COALESCE(SUM(jfs.revenue), 0) as lifetime_revenue
FROM customer c
LEFT JOIN job j ON c.customer_id = j.customer_id
LEFT JOIN vw_job_financial_summary jfs ON j.job_id = jfs.job_id
WHERE c.customer_id = $1
GROUP BY c.customer_id, c.customer_name;

-- name: GetTechnicianPerformance :many
SELECT 
    t.technician_id,
    t.technician_name,
    COUNT(DISTINCT jt.job_id) as total_jobs,
    COALESCE(SUM(jt.hours_worked), 0) as total_hours,
    COALESCE(AVG(s.survey_score), 0) as avg_survey_score
FROM technician t
LEFT JOIN job_technician jt ON t.technician_id = jt.technician_id
LEFT JOIN survey s ON jt.job_id = s.job_id
WHERE jt.split_percentage > 0
GROUP BY t.technician_id, t.technician_name
ORDER BY total_jobs DESC;

-- name: GetRevenueByBusinessUnit :many
SELECT 
    bu.business_unit_name,
    COUNT(DISTINCT j.job_id) as total_jobs,
    COALESCE(SUM(jfs.revenue), 0) as total_revenue,
    COALESCE(AVG(jfs.revenue), 0) as avg_revenue_per_job
FROM business_unit bu
LEFT JOIN job j ON bu.business_unit_id = j.business_unit_id
LEFT JOIN vw_job_financial_summary jfs ON j.job_id = jfs.job_id
WHERE j.job_status = 'Completed'
    AND j.job_completion_date BETWEEN $1 AND $2
GROUP BY bu.business_unit_id, bu.business_unit_name
ORDER BY total_revenue DESC;

-- name: GetConversionRateByTechnician :many
SELECT 
    t.technician_id,
    t.technician_name,
    COUNT(DISTINCT e.estimate_id) as total_estimates,
    COUNT(DISTINCT CASE WHEN e.is_sold THEN e.estimate_id END) as sold_estimates,
    CASE 
        WHEN COUNT(DISTINCT e.estimate_id) > 0 
        THEN ROUND(100.0 * COUNT(DISTINCT CASE WHEN e.is_sold THEN e.estimate_id END) / COUNT(DISTINCT e.estimate_id), 2)
        ELSE 0 
    END as conversion_rate
FROM technician t
LEFT JOIN job j ON t.technician_id = j.sold_by_technician_id
LEFT JOIN estimate e ON j.job_id = e.job_id
GROUP BY t.technician_id, t.technician_name
HAVING COUNT(DISTINCT e.estimate_id) > 0
ORDER BY conversion_rate DESC;

-- name: GetJobCountByStatus :many
SELECT 
    job_status,
    COUNT(*) as job_count
FROM job
GROUP BY job_status
ORDER BY job_count DESC;

-- name: GetJobsByDateRangeWithTotals :many
SELECT 
    j.job_id,
    j.job_creation_date,
    j.job_status,
    c.customer_name,
    jfs.job_total,
    jfs.revenue
FROM job j
JOIN customer c ON j.customer_id = c.customer_id
LEFT JOIN vw_job_financial_summary jfs ON j.job_id = jfs.job_id
WHERE j.job_creation_date BETWEEN $1 AND $2
ORDER BY j.job_creation_date DESC;