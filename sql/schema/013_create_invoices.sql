-- +goose Up
CREATE TABLE invoices (
    id INT PRIMARY KEY NOT NULL,
    customer_id INT NOT NULL,
    job_id INT,
    estimate_id INT,
    is_paid BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
    -- Note: job_id and estimate_id FKs added later due to circular dependencies
);

-- +goose Down
DROP TABLE invoices;