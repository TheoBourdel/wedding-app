package tests

import (
	"regexp"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"api/model"
	"api/service"
)

func TestCreateBudget(t *testing.T) {
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

	newBudget := model.WeddingBudget{
		WeddingID:  1,
		CategoryID: 1,
		Amount:     5000.0,
	}

	mock.ExpectBegin()
	mock.ExpectQuery(regexp.QuoteMeta(`INSERT INTO "wedding_budgets" ("wedding_id","category_id","amount","created_at","updated_at","deleted_at") VALUES ($1,$2,$3,$4,$5,$6) RETURNING "id"`)).
		WithArgs(newBudget.WeddingID, newBudget.CategoryID, newBudget.Amount, sqlmock.AnyArg(), sqlmock.AnyArg(), sqlmock.AnyArg()).
		WillReturnRows(sqlmock.NewRows([]string{"id"}).AddRow(1))
	mock.ExpectCommit()
    budgetService := service.NewBudgetService(gormDB)
	createdBudget, err := budgetService.Create(newBudget)
	if err != nil {
		t.Fatalf("failed to create budget: %v", err)
	}

	if createdBudget.CategoryID != newBudget.CategoryID {
		t.Errorf("expected category ID %d, got %d", newBudget.CategoryID, createdBudget.CategoryID)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

func TestFindByWeddingID(t *testing.T) {
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

	weddingID := uint(1)
	expectedBudgets := []model.WeddingBudget{
		{WeddingID: weddingID, CategoryID: 1, Amount: 5000.0},
		{WeddingID: weddingID, CategoryID: 2, Amount: 3000.0},
	}

	mock.ExpectQuery(regexp.QuoteMeta(`SELECT * FROM "wedding_budgets" WHERE wedding_id = $1`)).
		WithArgs(weddingID).
		WillReturnRows(sqlmock.NewRows([]string{"wedding_id", "category_id", "amount"}).
			AddRow(expectedBudgets[0].WeddingID, expectedBudgets[0].CategoryID, expectedBudgets[0].Amount).
			AddRow(expectedBudgets[1].WeddingID, expectedBudgets[1].CategoryID, expectedBudgets[1].Amount))

	budgetService := service.NewBudgetService(gormDB)
	actualBudgets, err := budgetService.FindByWeddingID(weddingID)
	if err != nil {
		t.Fatalf("failed to find budgets: %v", err)
	}

	if len(actualBudgets) != len(expectedBudgets) {
		t.Errorf("expected %d budgets, got %d", len(expectedBudgets), len(actualBudgets))
	}

	for i, budget := range actualBudgets {
		if budget.CategoryID != expectedBudgets[i].CategoryID {
			t.Errorf("expected category ID %d, got %d", expectedBudgets[i].CategoryID, budget.CategoryID)
		}
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

func TestGetTotalBudget(t *testing.T) {
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

	weddingID := uint(1)
	expectedTotal := 10000.0

	mock.ExpectQuery(regexp.QuoteMeta(`SELECT budget FROM "weddings" WHERE id = $1`)).
		WithArgs(weddingID).
		WillReturnRows(sqlmock.NewRows([]string{"budget"}).AddRow(expectedTotal))

	budgetService := service.NewBudgetService(gormDB)
	actualTotal, err := budgetService.GetTotalBudget(weddingID)
	if err != nil {
		t.Fatalf("failed to get total budget: %v", err)
	}

	if actualTotal != expectedTotal {
		t.Errorf("expected total budget %f, got %f", expectedTotal, actualTotal)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
