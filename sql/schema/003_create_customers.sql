-- +goose Up
CREATE TABLE customers (
    id INT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    city TEXT,
    state TEXT,
    zip TEXT,
    type TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- +goose Down
DROP TABLE customers;