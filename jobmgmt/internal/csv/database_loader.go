package csv

import (
	"fmt"
	"strconv"
	"strings"

	_ "github.com/lib/pq"
)

/* okay so the idea with this package is that i need to convert the strings that are read from the database into the proper types of their respective fields. so in with that in mind I will need to do a few things:
1. I need to assign types based on the column header
2. I'll need to convert the field based on the index of the header and type match.
3. I'll then need to store that into the database.

I have created a csv of the expected headers for my csv and then mapped those to the appropriate data type for the database.
So I am going to call my csv reader which will read this into a list of maps then to make it easier to use I can create a standard map.

once all that is done that should functionally speaking give me a solid database that I can now build specific queries around based on the information desired.*/

// take the contents of the csv file so the []map[string]strign and the header types map and output the appropriate type.
func convertValue(value, dataType string) (interface{}, error) {
	if value == "" || strings.ToLower(value) == "null" {
		return nil, nil
	}

	switch strings.ToLower(dataType) {
	case "int":
		return strconv.ParseInt(value, 10, 64)
	case "decimal":
		return strconv.ParseFloat(value, 64)
	case "boolean":
		return strconv.ParseBool(value)
	case "string":
		return value, nil
	default:
		return value, nil
	}
}

func ConvertCSVData(data []map[string]string, typeMap map[string]string) ([]map[string]interface{}, error) {
	result := make([]map[string]interface{}, len(data))

	for i, row := range data {
		convertedRow := make(map[string]interface{})

		for key, value := range row {
			dataType, exists := typeMap[key]
			if !exists {
				convertedRow[key] = value
				continue
			}
			converted, err := convertValue(value, dataType)
			if err != nil {
				return nil, fmt.Errorf("row %d, column %s: %w", i, key, err)
			}
			convertedRow[key] = converted
		}
		result[i] = convertedRow
	}
	return result, nil
}

/* as i go through the csv file each column needs to be addressed to determine if the column represents data from another table or if it is only related to data of the job.
if it is related then i need to verify if that data exists in the related table. If not we need to add it, if it does then we should simply reference it.*/

func ProcessMapToStruct(data []map[string]string) ([]Job, error) {
	jobsData := []Job{}

	for _, job := range data {
		jobsData = append(jobsData, Job{
			JobID:                     job["Job ID"],
			JobType:                   job["Job Type"],
			Status:                    job["Status"],
			JobsSubtotal:              job["Jobs Subtotal"],
			CreatedDate:               job["Created Date"],
			ScheduledDate:             job["Scheduled Date"],
			CompletionDate:            job["Completion Date"],
			CustomerID:                job["Customer ID"],
			LocationID:                job["Location ID"],
			AssignedTechnicians:       job["Assigned Technicians"],
			SoldBy:                    job["Sold By"],
			SoldByBusinessUnitID:      job["Sold By Business Unit ID"],
			Estimates:                 job["Estimates"],
			JobsEstimateSalesSubtotal: job["Jobs Estimate Sales Subtotal"],
			JobCampaignID:             job["Job Campaign"],
			CallCampaignID:            job["Call Campaign ID"],
			CampaignCategory:          job["Campaign Category"],
			BusinessUnitID:            job["Business Unit ID"],
			InvoiceID:                 job["Invoice ID"],
			Summary:                   job["Summary"],
			ProjectNumber:             job["Project Number"],
			Opportunity:               job["Opportunity"],
			Warranty:                  job["Warranty"],
			WarrantyFor:               job["Warranty For"],
			Recall:                    job["Recall"],
			RecallFor:                 job["Recall For"],
			Converted:                 job["Converted"],
			SurveyResult:              job["Survey Result"],
			DispatchedBy:              job["Dispatched By"],
			BookedBy:                  job["Booked By"],
			Priority:                  job["Priority"],
			LeadCreated:               job["Lead Created"],
			ZeroDollarJob:             job["Zero Dollar Job"],
			JobsTotal:                 job["Job Total"],
			ScheduledTime:             job["Scheduled Time"],
			ScheduledDateYearMonth:    job["Scheduled Date Year Month"],
			FirstDispatch:             job["First Dispatch"],
			HoldDate:                  job["Hold Date"],
			SoldOn:                    job["Sold On"],
			StartOfWorkingTime:        job["Start Of Working Time"],
			EndOfWorkingTime:          job["End Of Working Time"],
			CustomerType:              job["Customer Type"],
			MemberStatus:              job["Member Status"],
			PrimaryTechnician:         job["Primary Technician"],
			FirstResponseTime:         job["First Response Time"],
			TotalHoursWorked:          job["Total Hours Worked"],
			Tags:                      job["Tags"],
		})
	}
	return jobsData, nil
}

func InsertCustomer(data []map[string]string)

func InsertJobTypes(data []map[string]string) error {

}

// I am going to define the mini functions here and then define the actual handler else where in a separate package
