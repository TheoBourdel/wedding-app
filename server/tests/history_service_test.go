package tests

import (
	"testing"
	"github.com/DATA-DOG/go-sqlmock"
	"api/service"
	"regexp"
)

func TestWeddingsByYear(t *testing.T) {
	db, mock := setupTestDB(t)
	historyService := service.HistoryService{DB: db}

	year := 2023
	mock.ExpectQuery(regexp.QuoteMeta(`SELECT name, budget FROM "weddings" WHERE EXTRACT(YEAR FROM created_at) = $1`)).
		WithArgs(year).
		WillReturnRows(sqlmock.NewRows([]string{"name", "budget"}).
			AddRow("Wedding 1", 10000.0).
			AddRow("Wedding 2", 15000.0))

	weddings, err := historyService.WeddingsByYear(year)
	if err != nil {
		t.Fatalf("failed to fetch weddings: %v", err)
	}

	expectedWeddings := []service.WeddingDetail{
		{Name: "Wedding 1", Budget: 10000.0},
		{Name: "Wedding 2", Budget: 15000.0},
	}

	if len(weddings) != len(expectedWeddings) {
		t.Errorf("expected %d weddings, got %d", len(expectedWeddings), len(weddings))
	}

	for i, wedding := range weddings {
		if wedding.Name != expectedWeddings[i].Name || wedding.Budget != expectedWeddings[i].Budget {
			t.Errorf("expected wedding %v, got %v", expectedWeddings[i], wedding)
		}
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
