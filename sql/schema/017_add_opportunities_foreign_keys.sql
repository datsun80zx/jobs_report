-- +goose Up
ALTER TABLE opportunities
ADD FOREIGN KEY (jobs_id) REFERENCES jobs(id);


-- +goose Down
ALTER TABLE opportunities
DROP CONSTRAINT invoices_jobs_id_fkey;
