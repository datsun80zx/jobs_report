package main

import (
	"fmt"
	"log"
	"os"

	internal "github.com/datsun80zx/jobs_report.git/jobmgmt/internal/csv"
	"github.com/joho/godotenv"
)

type EnvConfig struct {
	TestCXPath        string
	TestJobPath       string
	CustomerDataPath  string
	JobSkillsDataPath string
	JobTypesDataPath  string
	JobDataPath       string
	HeaderTypesPath   string
}

func loadEnvConfig() EnvConfig {
	required := map[string]*string{
		"TEST_CX_DATA":  new(string),
		"TEST_JOB_DATA": new(string),
		"CX_DATA":       new(string),
		"JOB_SKILLS":    new(string),
		"JOB_TYPES":     new(string),
		"JOB_DATA":      new(string),
		"HEADER_TYPES":  new(string),
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
	return EnvConfig{
		TestCXPath:        *required["TEST_CX_DATA"],
		TestJobPath:       *required["TEST_JOB_DATA"],
		CustomerDataPath:  *required["CX_DATA"],
		JobSkillsDataPath: *required["JOB_SKILLS"],
		JobTypesDataPath:  *required["JOB_TYPES"],
		JobDataPath:       *required["JOB_DATA"],
		HeaderTypesPath:   *required["HEADER_TYPES"],
	}
}

func main() {
	err := godotenv.Load("C:/Users/mrich/dev_work/jobs_report/.env")
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	config := loadEnvConfig()
	results, err := internal.ReadCSVAsMap(config.TestJobPath)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	// for k, v := range results[0] {
	// 	fmt.Printf("Key is: '%s'(len=%d)...Value is: '%s'\n", k, len(k), v)
	// }

	fmt.Printf("Job ID: %s\n", results[0]["Job ID"])
	// fmt.Printf("Job ID: %v\n", results[0])

	jobStructured, err := internal.ProcessMapToStruct(results)
	if err != nil {
		fmt.Printf("error: %v", err)
	}

	for i, row := range jobStructured {
		fmt.Printf("\nRow %d:...\n\n", i)
		fmt.Printf("%#v\n", row)

	}

	// results, err := internal.ReadCSVHeaderTypes(config.HeaderTypesPath)
	// if err != nil {
	// 	fmt.Println("Error:", err)
	// 	return
	// }

	// for k, v := range results {
	// 	fmt.Printf("Key: %v....Value: %v\n\n", k, v)

	// }
	// fmt.Printf("total headers: %d\n", len(results))
}
