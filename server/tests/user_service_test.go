package tests
/*
import (
	"testing"

	"github.com/DATA-DOG/go-sqlmock"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"api/service"
	"api/model"
	"api/repository"
	"api/dto"
)

func TestCreateUser(t *testing.T) {
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

	mock.ExpectQuery(`SELECT \* FROM "users" WHERE email = \$1 AND "users"\."deleted_at" IS NULL`).
		WithArgs("john@example.com").
		WillReturnRows(sqlmock.NewRows(nil))

	mock.ExpectBegin()
	mock.ExpectExec(`INSERT INTO "users" \("created_at","updated_at","deleted_at","firstname","lastname","email","password","android_token","role"\) VALUES \(\?,?,?,?,?,?,?,?,\?\)`).
		WithArgs(sqlmock.AnyArg(), sqlmock.AnyArg(), sqlmock.AnyArg(), "John", "Doe", "john@example.com", sqlmock.AnyArg(), "", "admin").
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	userRepo := repository.NewUserRepository(gormDB)
	userService := service.UserService{UserRepository: *userRepo}

	user := model.User{
		Firstname: "John",
		Lastname:  "Doe",
		Email:     "john@example.com",
		Role:      model.Admin,
	}
	createdUser, errDto := userService.CreateUser(user)
	if errDto != (dto.HttpErrorDto{}) {
		t.Fatalf("failed to create user: %v", errDto)
	}

	if createdUser.Email != "john@example.com" {
		t.Errorf("expected user email to be 'john@example.com', got '%s'", createdUser.Email)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
func TestGetUser(t *testing.T) {
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

	mock.ExpectQuery(`SELECT \* FROM "users" WHERE id = \$1 AND "users"\."deleted_at" IS NULL`).
		WithArgs("1").
		WillReturnRows(sqlmock.NewRows([]string{"id", "firstname", "lastname", "email", "role"}).
			AddRow(1, "John", "Doe", "john@example.com", "admin"))

	userRepo := repository.NewUserRepository(gormDB)
	userService := service.UserService{UserRepository: *userRepo}

	user, errDto := userService.GetUser("1")
	if errDto != (dto.HttpErrorDto{}) {
		t.Fatalf("failed to get user: %v", errDto)
	}

	if user.Email != "john@example.com" {
		t.Errorf("expected user email to be 'john@example.com', got '%s'", user.Email)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
*/