-- +goose Up
CREATE TABLE job_types (
    id INT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    business_unit_id INT,
    skills_id INT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (business_unit_id) REFERENCES business_units(id),
    FOREIGN KEY (skills_id) REFERENCES job_skills(id)
);

-- +goose Down
DROP TABLE job_types;