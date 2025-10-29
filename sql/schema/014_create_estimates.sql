-- +goose Up
CREATE TABLE estimates (
    id INT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    subtotal DECIMAL(10, 2),
    is_sold BOOLEAN DEFAULT FALSE,
    sold_by UUID,
    invoices_id INT,
    opportunities_id INT,
    jobs_id INT,
    sold_on_date TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (sold_by) REFERENCES technicians(id),
    FOREIGN KEY (invoices_id) REFERENCES invoices(id),
    FOREIGN KEY (opportunities_id) REFERENCES opportunities(id)
);

-- +goose Down
DROP TABLE estimates;