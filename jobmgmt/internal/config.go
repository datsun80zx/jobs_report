package internal

import (
	"github.com/datsun80zx/jobs_report.git/jobmgmt/internal/db"
)

type AppConfig struct {
	Database *db.Queries
}
