-- +goose Up
ALTER TABLE invoices
ADD FOREIGN KEY (job_id) REFERENCES jobs(id),
ADD FOREIGN KEY (estimate_id) REFERENCES estimates(id);

-- +goose Down
ALTER TABLE invoices
DROP CONSTRAINT invoices_job_id_fkey,
DROP CONSTRAINT invoices_estimate_id_fkey;