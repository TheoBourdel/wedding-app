package utils

import (
	"fmt"

	"github.com/jung-kurt/gofpdf"
)

type PdfGenerator struct {
}

func (pg *PdfGenerator) GeneratePdf(name string) bool {
	pdf := gofpdf.New("P", "mm", "A4", "")
	pdf.AddPage()
	pdf.SetFont("Arial", "B", 16)
	pdf.Cell(40, 10, "Hello, world")
	// save in specific directory

	//err := pdf.OutputFileAndClose("hello.pdf")
	err := pdf.OutputFileAndClose("./uploads/pdf/" + name + ".pdf")

	if err != nil {
		fmt.Println("Error while generating PDF: ", err.Error())
		return false
	}

	return true
}
