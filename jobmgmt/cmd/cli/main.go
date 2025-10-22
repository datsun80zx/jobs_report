package main

import (
	"context"
	"os"

	"github.com/datsun80zx/jobs_report/internal/db"
	"github.com/fatih/color"
	"github.com/spf13/cobra"
)

var (
	successColor = color.New(color.FgGreen, color.Bold)
	errorColor   = color.New(color.FgRed, color.Bold)
	headerColor  = color.New(color.FgCyan, color.Bold)
	infoColor    = color.New(color.FgYellow)
)

type App struct {
	queries *db.Queries
	ctx     context.Context
}

func main() {

	dbConn := setupDatabase()
	queries := db.New(dbConn)

	app := &App{
		queries: queries,
		ctx:     context.Background(),
	}

	rootCmd := &cobra.Command{
		Use:   "jobmgmt",
		Short: "Job Management CLI Tool",
		Long:  "A CLI tool for managing and viewing job data",
	}

	rootCmd.AddCommand(app.listJobsCmd())
	rootCmd.AddCommand(app.jobDetailsCmd())
	rootCmd.AddCommand(app.customerReportCmd())
	rootCmd.AddCommand(app.technicianReportCmd())
	rootCmd.AddCommand(app.revenueReportCmd())
	rootCmd.AddCommand(app.statsCmd())

	if err := rootCmd.Execute(); err != nil {
		errorColor.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}

}
