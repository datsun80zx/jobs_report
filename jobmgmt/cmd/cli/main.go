package main

import (
	"fmt"
	"log"
	"os"

	internal "github.com/datsun80zx/jobs_report.git/jobmgmt/internal/csv"
	"github.com/joho/godotenv"
)

type Config struct {
	TestCXPath        string
	TestJobPath       string
	CustomerDataPath  string
	JobSkillsDataPath string
	JobTypesDataPath  string
	JobDataPath       string
}

func loadConfig() Config {
	required := map[string]*string{
		"TEST_CX_DATA":  new(string),
		"TEST_JOB_DATA": new(string),
		"CX_DATA":       new(string),
		"JOB_SKILLS":    new(string),
		"JOB_TYPES":     new(string),
		"JOB_DATA":      new(string),
	}

	var missing []string
	for key, ptr := range required {
		*ptr = os.Getenv(key)
		if *ptr == "" {
			missing = append(missing, key)
		}
	}

	if len(missing) > 0 {
		log.Fatalf("Missing required environment variables: %v", missing)
	}
	return Config{
		TestCXPath:        *required["TEST_CX_DATA"],
		TestJobPath:       *required["TEST_JOB_DATA"],
		CustomerDataPath:  *required["CX_DATA"],
		JobSkillsDataPath: *required["JOB_SKILLS"],
		JobTypesDataPath:  *required["JOB_TYPES"],
		JobDataPath:       *required["JOB_DATA"],
	}
}

func main() {
	err := godotenv.Load("C:/Users/mrich/dev_work/jobs_report/.env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	config := loadConfig()
	results, err := internal.ReadCSVAsMap(config.TestCXPath)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	for i, row := range results {
		fmt.Printf("Row %d:\n\n", i)
		for i, col := range row {
			fmt.Printf("Field: %v  Value: %v\n\n", i, col)
		}
	}

}
