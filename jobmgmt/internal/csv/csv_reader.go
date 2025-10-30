package csv

import (
	"encoding/csv"
	"fmt"
	"os"
	"strings"
	"unicode"
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

func ReadCSVAsMap(filename string) ([]map[string]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	reader := csv.NewReader(file)
	rows, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}

	if len(rows) == 0 {
		return nil, fmt.Errorf("empty CSV file")
	}

	// get list of headers:
	headers := make([]string, len(rows[0]))
	for i, header := range rows[0] {
		// fmt.Printf("Header %d raw bytes: %q\n", i, header)
		// fmt.Printf("Header %d runes: ", i)
		// for _, r := range header {
		// 	fmt.Printf("[U+%04X]", r)
		// }
		// fmt.Println()
		if i == 0 {
			header = strings.TrimPrefix(header, "\ufeff")
		}
		headers[i] = trimAll(header)
	}

	// remaining rows data:
	results := make([]map[string]string, 0, len(rows)-1)
	for _, row := range rows[1:] {
		record := make(map[string]string)
		for i, header := range headers {
			if i < len(row) {
				record[header] = trimAll(row[i])
			}
		}
		results = append(results, record)
	}
	return results, nil
}
func trimAll(s string) string {
	return strings.TrimFunc(s, func(r rune) bool {
		return unicode.IsSpace(r) || unicode.IsControl(r)
	})
}
func ReadCSVHeaderTypes(filename string) (map[string]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	reader := csv.NewReader(file)
	rows, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}

	if len(rows) < 2 {
		return nil, fmt.Errorf("empty CSV file")
	}

	// remaining rows data:
	results := make(map[string]string)
	for i, row := range rows[1:] {
		if len(row) < 2 {
			return nil, fmt.Errorf("row %d has fewer than 2 columns", i+2)
		}
		results[row[0]] = row[1]
	}
	return results, nil
}
