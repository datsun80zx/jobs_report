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

func InsertDataToDB()
