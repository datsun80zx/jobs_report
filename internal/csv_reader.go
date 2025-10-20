package internal

import (
	"encoding/csv"
	"fmt"
	"os"
	"strings"
)

func GetCSVHeader(filename string, reqFields []string) (map[string]int, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, fmt.Errorf("there was an error with opening %s: %v", filename, err)
	}

	defer file.Close()

	r := csv.NewReader(file)

	header, err := r.Read()
	if err != nil {
		return nil, fmt.Errorf("there was an error with reading the header in %s: %v", filename, err)
	}

	columnIndices := make(map[string]int)
	for i, columnName := range header {
		cleanName := strings.TrimSpace(strings.ToLower(columnName))
		columnIndices[cleanName] = i
	}
	if reqFields != nil {
		for _, colName := range reqFields {
			normalizedName := strings.ToLower(strings.TrimSpace(colName))
			if _, exists := columnIndices[normalizedName]; !exists {
				return nil, fmt.Errorf("required column '%s' not found in csv header", colName)
			}
		}
		return columnIndices, nil
	}
	return columnIndices, nil
}
