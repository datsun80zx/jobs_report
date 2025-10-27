-- +goose Up
CREATE TABLE projects (
    id INT PRIMARY KEY NOT NULL,
    summary TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- +goose Down
DROP TABLE projects;