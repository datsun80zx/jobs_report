package service

import (
	"database/sql"

	"github.com/datsun80zx/jobs_report.git/jobmgmt/internal/db"
)

type JobService struct {
	queries *db.Queries
}

func NewJobService(database *sql.DB) *JobService {
	return &JobService{
		queries: db.New(database),
	}
}
