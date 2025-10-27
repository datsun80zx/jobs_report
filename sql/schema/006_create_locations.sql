-- +goose Up
CREATE TABLE locations (
    id INT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    city TEXT,
    state TEXT,
    zip TEXT,
    customer_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- +goose Down
DROP TABLE locations;