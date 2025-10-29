-- +goose Up
ALTER TABLE invoices
ADD FOREIGN KEY (jobs_id) REFERENCES jobs(id),
ADD FOREIGN KEY (estimates_id) REFERENCES estimates(id);

-- +goose Down
ALTER TABLE invoices
DROP CONSTRAINT invoices_jobs_id_fkey,
DROP CONSTRAINT invoices_estimates_id_fkey;