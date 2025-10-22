package cli

import(
	"context"
	"fmt"
	"os"
	"strconv"
	"time"

	"github.com/fatih/color"
	"github.com/olekukonko/tablewriter"
	"github.com/spf13/cobra"
)

var (
	successColor = color.New(color.FgGreen, color.Bold)
	errorColor   = color.New(color.FgRed, color.Bold)
	headerColor  = color.New(color.FgCyan, color.Bold)
	infoColor    = color.New(color.FgYellow)
)

func MakeTable([])