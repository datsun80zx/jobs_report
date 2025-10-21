-- +goose Up
-- +goose StatementBegin

-- =====================================================
-- CORE ENTITY TABLES
-- =====================================================

-- App Users (renamed from User to avoid reserved keyword)
CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Business Units
CREATE TABLE business_unit (
    business_unit_id SERIAL PRIMARY KEY,
    business_unit_name VARCHAR(255) NOT NULL UNIQUE
);

-- Technicians
CREATE TABLE technician (
    technician_id SERIAL PRIMARY KEY,
    technician_name VARCHAR(255) NOT NULL,
    business_unit_id INT,
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (business_unit_id) REFERENCES business_unit(business_unit_id)
);

-- Campaign Categories
CREATE TABLE campaign_category (
    campaign_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);

-- Campaigns (both Job and Call campaigns)
CREATE TABLE campaign (
    campaign_id SERIAL PRIMARY KEY,
    campaign_name VARCHAR(255) NOT NULL,
    campaign_category_id INT,
    campaign_type VARCHAR(20) NOT NULL CHECK (campaign_type IN ('Job', 'Call')),
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (campaign_category_id) REFERENCES campaign_category(campaign_category_id)
);

-- Job Types
CREATE TABLE job_type (
    job_type_id SERIAL PRIMARY KEY,
    job_type_name VARCHAR(255) NOT NULL UNIQUE,
    sold_threshold DECIMAL(10,2) DEFAULT 0.00
);

-- Projects
CREATE TABLE project (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- General Ledger Accounts
CREATE TABLE general_ledger_account (
    gl_account_id SERIAL PRIMARY KEY,
    account_code VARCHAR(50) NOT NULL UNIQUE,
    account_name VARCHAR(255) NOT NULL,
    account_type VARCHAR(20) NOT NULL CHECK (account_type IN ('Income', 'Expense', 'Asset', 'Liability', 'Equity'))
);

-- =====================================================
-- CUSTOMER RELATED TABLES
-- =====================================================

-- Customers
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    customer_type VARCHAR(20) NOT NULL CHECK (customer_type IN ('Residential', 'Commercial')),
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Locations (service addresses)
CREATE TABLE location (
    location_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    city VARCHAR(100),
    state VARCHAR(50),
    zip_code VARCHAR(20),
    street_address VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- Memberships
CREATE TABLE membership (
    membership_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    membership_type VARCHAR(100),
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Active', 'Inactive')),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- =====================================================
-- JOB RELATED TABLES
-- =====================================================

-- Jobs
CREATE TABLE job (
    job_id INT PRIMARY KEY,
    job_type_id INT NOT NULL,
    business_unit_id INT NOT NULL,
    customer_id INT NOT NULL,
    location_id INT NOT NULL,
    project_id INT,
    job_campaign_id INT,
    call_campaign_id INT,
    job_status VARCHAR(20) NOT NULL CHECK (job_status IN ('Scheduled', 'In Progress', 'On Hold', 'Canceled', 'Completed')),
    priority VARCHAR(50),
    summary TEXT,
    job_creation_date DATE NOT NULL,
    job_schedule_date DATE,
    job_completion_date DATE,
    scheduled_time TIME,
    first_dispatch_date TIMESTAMP,
    hold_date DATE,
    start_of_work_time TIMESTAMP,
    end_of_work_time TIMESTAMP,
    booked_by_user_id INT,
    dispatched_by_user_id INT,
    sold_by_technician_id INT,
    is_warranty BOOLEAN DEFAULT FALSE,
    warranty_for_job_id INT,
    is_recall BOOLEAN DEFAULT FALSE,
    recall_for_job_id INT,
    FOREIGN KEY (job_type_id) REFERENCES job_type(job_type_id),
    FOREIGN KEY (business_unit_id) REFERENCES business_unit(business_unit_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (project_id) REFERENCES project(project_id),
    FOREIGN KEY (job_campaign_id) REFERENCES campaign(campaign_id),
    FOREIGN KEY (call_campaign_id) REFERENCES campaign(campaign_id),
    FOREIGN KEY (booked_by_user_id) REFERENCES app_user(user_id),
    FOREIGN KEY (dispatched_by_user_id) REFERENCES app_user(user_id),
    FOREIGN KEY (sold_by_technician_id) REFERENCES technician(technician_id),
    FOREIGN KEY (warranty_for_job_id) REFERENCES job(job_id),
    FOREIGN KEY (recall_for_job_id) REFERENCES job(job_id)
);

-- Job Technician Assignment (with split percentages)
CREATE TABLE job_technician (
    job_technician_id SERIAL PRIMARY KEY,
    job_id INT NOT NULL,
    technician_id INT NOT NULL,
    split_percentage DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    assignment_order INT NOT NULL,
    hours_worked DECIMAL(5,2),
    FOREIGN KEY (job_id) REFERENCES job(job_id),
    FOREIGN KEY (technician_id) REFERENCES technician(technician_id),
    UNIQUE (job_id, technician_id)
);

-- Estimates
CREATE TABLE estimate (
    estimate_id SERIAL PRIMARY KEY,
    job_id INT NOT NULL,
    estimate_subtotal DECIMAL(10,2) NOT NULL,
    is_sold BOOLEAN DEFAULT FALSE,
    sold_on_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES job(job_id)
);

-- Invoices
CREATE TABLE invoice (
    invoice_id INT PRIMARY KEY,
    job_id INT NOT NULL,
    invoice_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES job(job_id)
);

-- Invoice Items
CREATE TABLE invoice_item (
    invoice_item_id SERIAL PRIMARY KEY,
    invoice_id INT NOT NULL,
    gl_account_id INT,
    description VARCHAR(255),
    quantity DECIMAL(10,2) NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    item_order INT,
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (gl_account_id) REFERENCES general_ledger_account(gl_account_id)
);

-- Surveys
CREATE TABLE survey (
    survey_id SERIAL PRIMARY KEY,
    job_id INT NOT NULL,
    survey_score DECIMAL(3,2),
    survey_date DATE,
    comments TEXT,
    FOREIGN KEY (job_id) REFERENCES job(job_id),
    UNIQUE (job_id)
);

-- Lead Tracking (jobs created from other jobs)
CREATE TABLE job_lead (
    job_lead_id SERIAL PRIMARY KEY,
    source_job_id INT NOT NULL,
    lead_job_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_job_id) REFERENCES job(job_id),
    FOREIGN KEY (lead_job_id) REFERENCES job(job_id)
);

-- =====================================================
-- TAG TABLES (separate pools)
-- =====================================================

-- Job Tags
CREATE TABLE job_tag (
    job_tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE job_tag_assignment (
    job_id INT NOT NULL,
    job_tag_id INT NOT NULL,
    PRIMARY KEY (job_id, job_tag_id),
    FOREIGN KEY (job_id) REFERENCES job(job_id),
    FOREIGN KEY (job_tag_id) REFERENCES job_tag(job_tag_id)
);

-- Customer Tags
CREATE TABLE customer_tag (
    customer_tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE customer_tag_assignment (
    customer_id INT NOT NULL,
    customer_tag_id INT NOT NULL,
    PRIMARY KEY (customer_id, customer_tag_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (customer_tag_id) REFERENCES customer_tag(customer_tag_id)
);

-- Location Tags
CREATE TABLE location_tag (
    location_tag_id SERIAL PRIMARY KEY,
    tag_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE location_tag_assignment (
    location_id INT NOT NULL,
    location_tag_id INT NOT NULL,
    PRIMARY KEY (location_id, location_tag_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id),
    FOREIGN KEY (location_tag_id) REFERENCES location_tag(location_tag_id)
);

-- =====================================================
-- VIEWS FOR CALCULATED/DERIVED FIELDS
-- =====================================================

-- View for Job financial summary
CREATE VIEW vw_job_financial_summary AS
SELECT 
    j.job_id,
    COALESCE(SUM(ii.amount), 0) as job_subtotal,
    COALESCE(SUM(ii.amount + ii.tax_amount), 0) as job_total,
    COALESCE(SUM(CASE WHEN gla.account_type = 'Income' THEN ii.amount ELSE 0 END), 0) as revenue,
    CASE WHEN COALESCE(SUM(CASE WHEN gla.account_type = 'Income' THEN ii.amount ELSE 0 END), 0) <= 0 
         THEN TRUE ELSE FALSE END as is_zero_dollar_job
FROM job j
LEFT JOIN invoice inv ON j.job_id = inv.job_id
LEFT JOIN invoice_item ii ON inv.invoice_id = ii.invoice_id
LEFT JOIN general_ledger_account gla ON ii.gl_account_id = gla.gl_account_id
GROUP BY j.job_id;

-- View for Sold Estimate total
CREATE VIEW vw_job_estimate_summary AS
SELECT 
    job_id,
    COUNT(*) as count_of_estimates,
    COALESCE(SUM(CASE WHEN is_sold = TRUE THEN estimate_subtotal ELSE 0 END), 0) as sold_estimate_subtotal
FROM estimate
GROUP BY job_id;

-- View for Primary Technician (highest split percentage)
CREATE VIEW vw_job_primary_technician AS
SELECT 
    jt.job_id,
    jt.technician_id as primary_technician_id,
    t.technician_name as primary_technician_name
FROM job_technician jt
INNER JOIN technician t ON jt.technician_id = t.technician_id
INNER JOIN (
    SELECT job_id, MAX(split_percentage) as max_split, MIN(assignment_order) as min_order
    FROM job_technician
    GROUP BY job_id
) max_splits ON jt.job_id = max_splits.job_id 
    AND jt.split_percentage = max_splits.max_split 
    AND jt.assignment_order = max_splits.min_order;

-- View for Total Hours Worked
CREATE VIEW vw_job_total_hours AS
SELECT 
    job_id,
    COALESCE(SUM(hours_worked), 0) as total_hours_worked
FROM job_technician
GROUP BY job_id;

-- View for Opportunity identification
CREATE VIEW vw_job_opportunity AS
SELECT 
    j.job_id,
    CASE 
        WHEN j.job_status = 'Completed' 
        AND j.is_warranty = FALSE 
        AND j.is_recall = FALSE 
        AND jfs.job_subtotal >= jt.sold_threshold
        THEN j.job_id
        ELSE NULL
    END as opportunity_id
FROM job j
LEFT JOIN vw_job_financial_summary jfs ON j.job_id = jfs.job_id
LEFT JOIN job_type jt ON j.job_type_id = jt.job_type_id;

-- View for Converted jobs
CREATE VIEW vw_job_converted AS
SELECT 
    j.job_id,
    CASE 
        WHEN j.job_status = 'Completed' 
        AND jfs.job_subtotal >= jt.sold_threshold
        THEN TRUE
        ELSE FALSE
    END as is_converted
FROM job j
LEFT JOIN vw_job_financial_summary jfs ON j.job_id = jfs.job_id
LEFT JOIN job_type jt ON j.job_type_id = jt.job_type_id;

-- View for Member Status
CREATE VIEW vw_customer_membership_status AS
SELECT 
    c.customer_id,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM membership m 
            WHERE m.customer_id = c.customer_id 
            AND m.status = 'Active'
        ) THEN 'Active'
        ELSE 'Inactive'
    END as member_status
FROM customer c;

-- View for First Response Time (dispatch to arrival)
CREATE VIEW vw_job_first_response_time AS
SELECT 
    j.job_id,
    EXTRACT(EPOCH FROM (j.start_of_work_time - j.first_dispatch_date)) / 60 as first_response_time_minutes
FROM job j
WHERE j.first_dispatch_date IS NOT NULL 
AND j.start_of_work_time IS NOT NULL;

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin

-- Drop views first
DROP VIEW IF EXISTS vw_job_first_response_time;
DROP VIEW IF EXISTS vw_customer_membership_status;
DROP VIEW IF EXISTS vw_job_converted;
DROP VIEW IF EXISTS vw_job_opportunity;
DROP VIEW IF EXISTS vw_job_total_hours;
DROP VIEW IF EXISTS vw_job_primary_technician;
DROP VIEW IF EXISTS vw_job_estimate_summary;
DROP VIEW IF EXISTS vw_job_financial_summary;

-- Drop tag assignment tables
DROP TABLE IF EXISTS location_tag_assignment;
DROP TABLE IF EXISTS customer_tag_assignment;
DROP TABLE IF EXISTS job_tag_assignment;

-- Drop tag tables
DROP TABLE IF EXISTS location_tag;
DROP TABLE IF EXISTS customer_tag;
DROP TABLE IF EXISTS job_tag;

-- Drop job-related tables (reverse order of creation)
DROP TABLE IF EXISTS job_lead;
DROP TABLE IF EXISTS survey;
DROP TABLE IF EXISTS invoice_item;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS estimate;
DROP TABLE IF EXISTS job_technician;
DROP TABLE IF EXISTS job;

-- Drop customer-related tables
DROP TABLE IF EXISTS membership;
DROP TABLE IF EXISTS location;
DROP TABLE IF EXISTS customer;

-- Drop reference tables
DROP TABLE IF EXISTS general_ledger_account;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS job_type;
DROP TABLE IF EXISTS campaign;
DROP TABLE IF EXISTS campaign_category;
DROP TABLE IF EXISTS technician;
DROP TABLE IF EXISTS business_unit;
DROP TABLE IF EXISTS app_user;

-- +goose StatementEnd