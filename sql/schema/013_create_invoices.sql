-- +goose Up
CREATE TABLE invoices (
    id INT PRIMARY KEY NOT NULL,
    customers_id INT NOT NULL,
    jobs_id INT,
    estimates_id INT,
    business_units_id INT,
    is_paid BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (customers_id) REFERENCES customers(id),
    FOREIGN KEY (business_units_id) REFERENCES business_units(id)
    -- Note: job_id and estimate_id FKs added later due to circular dependencies
);

-- +goose Down
DROP TABLE invoices;