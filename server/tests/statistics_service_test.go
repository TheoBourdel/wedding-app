package tests

import (
	"regexp"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"api/service"
	"api/model"
)

func TestTotalGuests(t *testing.T) {
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatalf("failed to create mock database: %v", err)
	}
	defer db.Close()
	dialector := postgres.New(postgres.Config{
		Conn: db,
	})
	gormDB, err := gorm.Open(dialector, &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open gorm DB connection: %v", err)
	}
	currentYear := time.Now().Year()
	startOfMonth := time.Date(currentYear, time.Now().Month(), 1, 0, 0, 0, 0, time.UTC)
	endOfMonth := startOfMonth.AddDate(0, 1, 0)
	mock.ExpectQuery(regexp.QuoteMeta(`SELECT count(*) FROM "users" WHERE (created_at >= $1 AND created_at < $2) AND "users"."deleted_at" IS NULL`)).
		WithArgs(startOfMonth, endOfMonth).
		WillReturnRows(sqlmock.NewRows([]string{"count"}).AddRow(2))
	svc := service.StatisticsService{DB: gormDB}
	count, err := svc.TotalGuests()
	if err != nil {
		t.Fatalf("failed to get total guests: %v", err)
	}
	expectedCount := int64(2)
	if count != expectedCount {
		t.Errorf("expected %d guests, got %d", expectedCount, count)
	}
	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

func TestTotalWeddings(t *testing.T) {
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatalf("failed to create mock database: %v", err)
	}
	defer db.Close()
	dialector := postgres.New(postgres.Config{
		Conn: db,
	})
	gormDB, err := gorm.Open(dialector, &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open gorm DB connection: %v", err)
	}
	mock.ExpectQuery(regexp.QuoteMeta(`SELECT count(*) FROM "weddings" WHERE "weddings"."deleted_at" IS NULL`)).
		WillReturnRows(sqlmock.NewRows([]string{"count"}).AddRow(10))
	svc := service.StatisticsService{DB: gormDB}
	count, err := svc.TotalWeddings()
	if err != nil {
		t.Fatalf("failed to get total weddings: %v", err)
	}
	expectedCount := int64(10)
	if count != expectedCount {
		t.Errorf("expected %d weddings, got %d", expectedCount, count)
	}
	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

func TestTotalProviders(t *testing.T) {
	// Create a new mock database
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatalf("failed to create mock database: %v", err)
	}
	defer db.Close()

	// Open a gorm DB connection using the mock database
	dialector := postgres.New(postgres.Config{
		Conn: db,
	})
	gormDB, err := gorm.Open(dialector, &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open gorm DB connection: %v", err)
	}

	// Set up expected queries and results
	mock.ExpectQuery(regexp.QuoteMeta(`SELECT count(*) FROM "users" WHERE role = $1 AND "users"."deleted_at" IS NULL`)).
		WithArgs(model.Provider).
		WillReturnRows(sqlmock.NewRows([]string{"count"}).AddRow(5))

	// Create the service
	svc := service.StatisticsService{DB: gormDB}

	// Run the test
	count, err := svc.TotalProviders()
	if err != nil {
		t.Fatalf("failed to get total providers: %v", err)
	}

	// Verify the result
	expectedCount := int64(5)
	if count != expectedCount {
		t.Errorf("expected %d providers, got %d", expectedCount, count)
	}

	// Ensure all expectations are met
	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
