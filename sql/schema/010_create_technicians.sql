-- +goose Up
CREATE TABLE technicians (
    id UUID PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone_number TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (id) REFERENCES users(id)
);

-- +goose Down
DROP TABLE technicians;