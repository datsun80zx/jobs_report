-- +goose Up
ALTER TABLE estimates
ADD FOREIGN KEY (jobs_id) REFERENCES jobs(id);


-- +goose Down
ALTER TABLE estimates
DROP CONSTRAINT estimates_jobs_id_fkey;
