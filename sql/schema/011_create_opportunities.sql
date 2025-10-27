-- +goose Up
CREATE TABLE opportunities (
    id INT PRIMARY KEY NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- +goose Down
DROP TABLE opportunities;