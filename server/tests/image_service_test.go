package tests

import (
	"regexp"
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"api/service"
	"api/repository"
	"api/config"
)

func setupTestDB(t *testing.T) (*gorm.DB, sqlmock.Sqlmock) {
	db, mock, err := sqlmock.New()
	if err != nil {
		t.Fatalf("failed to create mock database: %v", err)
	}

	dialector := postgres.New(postgres.Config{
		Conn: db,
	})
	gormDB, err := gorm.Open(dialector, &gorm.Config{})
	if err != nil {
		t.Fatalf("failed to open gorm DB connection: %v", err)
	}

	config.DB = gormDB // Set the global config.DB to our mock DB

	return gormDB, mock
}

func TestFindAllImages(t *testing.T) {
	_, mock := setupTestDB(t)
	imageRepo := repository.ImageRepository{DB: config.DB}
	userRepo := repository.UserRepository{DB: config.DB}
	imageService := service.ImageService{ImageRepository: imageRepo, UserRepository: userRepo}

	mock.ExpectQuery(regexp.QuoteMeta(`SELECT * FROM "images"`)).
		WillReturnRows(sqlmock.NewRows([]string{"id", "path", "service_id"}).
			AddRow(1, "http://example.com/image1.jpg", 1).
			AddRow(2, "http://example.com/image2.jpg", 2))

	images := imageService.FindAll()
	if len(images) != 2 {
		t.Errorf("expected 2 images, got %d", len(images))
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
