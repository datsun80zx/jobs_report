package csv

type Job struct {
	JobID                     string `csv:"Job ID"`
	JobType                   string `csv:"Job Type"`
	Status                    string `csv:"Status"`
	JobsSubtotal              string `csv:"Jobs Subtotal"`
	CreatedDate               string `csv:"Created Date"`
	ScheduledDate             string `csv:"Scheduled Date"`
	CompletionDate            string `csv:"Completion Date"`
	CustomerID                string `csv:"Customer ID"`
	LocationID                string `csv:"Location ID"`
	AssignedTechnicians       string `csv:"Assigned Technicians"`
	SoldBy                    string `csv:"Sold By"`
	SoldByBusinessUnitID      string `csv:"Sold By Business Unit ID"`
	Estimates                 string `csv:"Estimates"`
	JobsEstimateSalesSubtotal string `csv:"Jobs Estimate Sales Subtotal"`
	JobCampaignID             string `csv:"Job Campaign ID"`
	CallCampaignID            string `csv:"Call Campaign ID"`
	CampaignCategory          string `csv:"Campaign Category"`
	BusinessUnitID            string `csv:"Business Unit ID"`
	InvoiceID                 string `csv:"Invoice ID"`
	Summary                   string `csv:"Summary"`
	ProjectNumber             string `csv:"Project Number"`
	Opportunity               string `csv:"Opportunity"`
	Warranty                  string `csv:"Warranty"`
	WarrantyFor               string `csv:"Warranty For"`
	Recall                    string `csv:"Recall"`
	RecallFor                 string `csv:"Recall For"`
	Converted                 string `csv:"Converted"`
	SurveyResult              string `csv:"Survey Result"`
	DispatchedBy              string `csv:"Dispatched By"`
	BookedBy                  string `csv:"Booked By"`
	Priority                  string `csv:"Priority"`
	LeadCreated               string `csv:"Lead Created"`
	ZeroDollarJob             string `csv:"Zero Dollar Job"`
	JobsTotal                 string `csv:"Jobs Total"`
	ScheduledTime             string `csv:"Scheduled Time"`
	ScheduledDateYearMonth    string `csv:"Scheduled Date Year Month"`
	FirstDispatch             string `csv:"First Dispatch"`
	HoldDate                  string `csv:"Hold Date"`
	SoldOn                    string `csv:"Sold On"`
	StartOfWorkingTime        string `csv:"Start of Working Time"`
	EndOfWorkingTime          string `csv:"End of Working Time"`
	CustomerType              string `csv:"Customer Type"`
	MemberStatus              string `csv:"Member Status"`
	PrimaryTechnician         string `csv:"Primary Technician"`
	FirstResponseTime         string `csv:"First Response Time"`
	TotalHoursWorked          string `csv:"Total Hours Worked"`
	Tags                      string `csv:"Tags"`
}
