package tests

import (
	"regexp"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"api/service"
	"api/repository"
)


func TestFindAllCategories(t *testing.T) {
	db, mock := setupTestDB(t)
	categoryRepo := repository.CategoryRepository{DB: db}
	userRepo := repository.UserRepository{DB: db}
	categoryService := service.CategoryService{CategoryRepository: categoryRepo, UserRepository: userRepo}

	now := time.Now()
	mock.ExpectQuery(regexp.QuoteMeta(`SELECT * FROM "categories"`)).
		WillReturnRows(sqlmock.NewRows([]string{"id", "name", "created_at", "updated_at"}).
			AddRow(1, "Category 1", now, now).
			AddRow(2, "Category 2", now, now))

	categories := categoryService.FindAll()
	if len(categories) != 2 {
		t.Errorf("expected 2 categories, got %d", len(categories))
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
