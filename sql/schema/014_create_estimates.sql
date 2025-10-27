-- +goose Up
CREATE TABLE estimates (
    id INT PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    subtotal DECIMAL(10, 2),
    is_sold BOOLEAN DEFAULT FALSE,
    sold_by UUID,
    invoice_id INT,
    opportunity_id INT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (sold_by) REFERENCES technicians(id),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id),
    FOREIGN KEY (opportunity_id) REFERENCES opportunities(id)
);

-- +goose Down
DROP TABLE estimates;