-- +goose Up
CREATE TABLE opportunities (
    id INT PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    business_units_id INT,
    job_types_id INT,
    technicians_id UUID,
    jobs_id INT,
    FOREIGN KEY (business_units_id) REFERENCES business_units(id),
    FOREIGN KEY (job_types_id) REFERENCES job_types(id)
);

-- +goose Down
DROP TABLE opportunities;