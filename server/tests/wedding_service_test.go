package tests

import (
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"api/service"
	"api/repository"
)
func TestFindAllWeddings(t *testing.T) {
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

	mock.ExpectQuery(`SELECT \* FROM "weddings" WHERE "weddings"\."deleted_at" IS NULL`).
		WillReturnRows(sqlmock.NewRows([]string{"id", "address", "phone", "email", "budget", "date", "created_at", "updated_at", "deleted_at"}).
			AddRow(1, "123 Wedding St", "123-456-7890", "wedding@example.com", 10000.0, "2024-07-20", nil, nil, nil).
			AddRow(2, "456 Ceremony Ave", "987-654-3210", "ceremony@example.com", 15000.0, "2024-08-15", nil, nil, nil))

	weddingRepo := repository.NewWeddingRepository(gormDB)
	weddingService := service.WeddingService{WeddingRepository: *weddingRepo}

	weddings := weddingService.FindAll()
	if len(weddings) != 2 {
		t.Fatalf("expected 2 weddings, got %d", len(weddings))
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

/*
func setupTestDB() (*gorm.DB, sqlmock.Sqlmock, error) {
	db, mock, err := sqlmock.New()
	if err != nil {
		return nil, nil, err
	}

	dialector := postgres.New(postgres.Config{
		Conn: db,
	})
	gormDB, err := gorm.Open(dialector, &gorm.Config{})
	if err != nil {
		return nil, nil, err
	}

	return gormDB, mock, nil
}


func TestCreateWedding(t *testing.T) {
	gormDB, mock, err := setupTestDB()
	if err != nil {
		t.Fatalf("failed to set up test database: %v", err)
	}
	defer func() {
		db, _ := gormDB.DB()
		db.Close()
	}()

	mock.ExpectQuery(regexp.QuoteMeta(`SELECT * FROM "users" WHERE id = $1 AND "users"."deleted_at" IS NULL`)).
		WithArgs("1").
		WillReturnRows(sqlmock.NewRows([]string{"id", "created_at", "updated_at", "deleted_at", "firstname", "lastname", "email", "password", "android_token", "role"}).
			AddRow(1, time.Now(), time.Now(), nil, "John", "Doe", "john@example.com", "password", "", "marry"))

	mock.ExpectBegin()
	mock.ExpectExec(regexp.QuoteMeta(`INSERT INTO "weddings" ("created_at","updated_at","deleted_at","address","phone","email","budget","date") VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`)).
		WithArgs(sqlmock.AnyArg(), sqlmock.AnyArg(), sqlmock.AnyArg(), "123 Street", "1234567890", "test@example.com", 1000.0, sqlmock.AnyArg()).
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectExec(regexp.QuoteMeta(`INSERT INTO "organizers" ("wedding_id","user_id") VALUES ($1,$2)`)).
		WithArgs(sqlmock.AnyArg(), sqlmock.AnyArg()).
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	weddingRepo := repository.NewWeddingRepository(gormDB)
	userRepo := repository.NewUserRepository(gormDB)
	weddingService := service.NewWeddingService(*weddingRepo, *userRepo)

	userID := uint64(1)
	wedding := model.Wedding{
		Address: "123 Street",
		Phone:   "1234567890",
		Email:   "test@example.com",
		Budget:  1000.0,
		Date:    time.Now().String(),
	}

	createdWedding, errDto := weddingService.Create(userID, wedding)
	if errDto != (dto.HttpErrorDto{}) {
		t.Fatalf("failed to create wedding: %v", errDto)
	}

	if createdWedding.Email != "test@example.com" {
		t.Errorf("expected wedding email to be 'test@example.com', got '%s'", createdWedding.Email)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

func TestFindWeddingByID(t *testing.T) {
	gormDB, mock, err := setupTestDB()
	if err != nil {
		t.Fatalf("failed to set up test database: %v", err)
	}
	defer func() {
		db, _ := gormDB.DB()
		db.Close()
	}()

	mock.ExpectQuery(regexp.QuoteMeta(`SELECT * FROM "weddings" WHERE id = $1 AND "weddings"."deleted_at" IS NULL`)).
		WithArgs("1").
		WillReturnRows(sqlmock.NewRows([]string{"id", "created_at", "updated_at", "deleted_at", "address", "phone", "email", "budget", "date"}).
			AddRow(1, time.Now(), time.Now(), nil, "123 Street", "1234567890", "test@example.com", 1000.0, time.Now()))

	weddingRepo := repository.NewWeddingRepository(gormDB)
	userRepo := repository.NewUserRepository(gormDB)
	weddingService := service.NewWeddingService(*weddingRepo, *userRepo)

	weddingID := uint64(1)
	foundWedding, err := weddingService.FindByID(weddingID)
	if err != nil {
		t.Fatalf("failed to find wedding: %v", err)
	}

	if foundWedding.Email != "test@example.com" {
		t.Errorf("expected wedding email to be 'test@example.com', got '%s'", foundWedding.Email)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

func TestDeleteWedding(t *testing.T) {
	gormDB, mock, err := setupTestDB()
	if err != nil {
		t.Fatalf("failed to set up test database: %v", err)
	}
	defer func() {
		db, _ := gormDB.DB()
		db.Close()
	}()

	mock.ExpectQuery(regexp.QuoteMeta(`SELECT * FROM "weddings" WHERE id = $1 AND "weddings"."deleted_at" IS NULL`)).
		WithArgs("1").
		WillReturnRows(sqlmock.NewRows([]string{"id", "created_at", "updated_at", "deleted_at", "address", "phone", "email", "budget", "date"}).
			AddRow(1, time.Now(), time.Now(), nil, "123 Street", "1234567890", "test@example.com", 1000.0, time.Now()))
	mock.ExpectBegin()
	mock.ExpectExec(regexp.QuoteMeta(`DELETE FROM "weddings" WHERE "weddings"."id" = $1`)).
		WithArgs("1").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	weddingRepo := repository.NewWeddingRepository(gormDB)
	userRepo := repository.NewUserRepository(gormDB)
	weddingService := service.NewWeddingService(*weddingRepo, *userRepo)

	weddingID := uint64(1)
	err = weddingService.Delete(weddingID)
	if err != nil {
		t.Fatalf("failed to delete wedding: %v", err)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
*/