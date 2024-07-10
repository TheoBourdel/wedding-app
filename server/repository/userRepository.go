package repository

import (
	"api/dto"
	"api/model"

	"api/config"

	"fmt"

	"gorm.io/gorm"
)

type UserRepository struct {
	DB *gorm.DB
}

func NewUserRepository(db *gorm.DB) *UserRepository {
	return &UserRepository{DB: db}
}

func (ur *UserRepository) FindAll(page int, pageSize int, query string) []model.User {
	var users []model.User
	offset := (page - 1) * pageSize
	db := config.DB

	if query != "" {
		db = db.Where("firstname LIKE ? OR lastname LIKE ? OR email LIKE ?", "%"+query+"%", "%"+query+"%", "%"+query+"%")
	}

	result := db.Offset(offset).Limit(pageSize).Find(&users)
	if result.Error != nil {
		fmt.Printf("Error retrieving users: %v", result.Error)
		return []model.User{}
	}

	return users
}

func (ur *UserRepository) Create(user model.User) (model.User, dto.HttpErrorDto) {

	result := config.DB.Create(&user)
	if result.Error != nil {
		return model.User{}, dto.HttpErrorDto{Message: "Error while creating user", Code: 500}
	}

	return user, dto.HttpErrorDto{}
}

func (ur *UserRepository) FindOneBy(field string, value any) (model.User, dto.HttpErrorDto) {
	var user model.User

	result := config.DB.Where(field+" = ?", value).Preload("Weddings.User").First(&user)
	if result.RowsAffected == 0 {
		return model.User{}, dto.HttpErrorDto{Message: "User not found", Code: 404}
	}

	if result.Error != nil {
		return model.User{}, dto.HttpErrorDto{Message: "Error while fetching user", Code: 500}
	}

	return user, dto.HttpErrorDto{}
}

func (ur *UserRepository) FindAllByWeddingID(weddingID uint) ([]model.User, dto.HttpErrorDto) {
	var users []model.User

	result := config.DB.Joins("JOIN organizers ON users.id = organizers.user_id").Where("organizers.wedding_id = ?", weddingID).Find(&users)
	if result.Error != nil {
		return []model.User{}, dto.HttpErrorDto{Message: "Error while fetching users", Code: 500}
	}

	return users, dto.HttpErrorDto{}
}

func (ur *UserRepository) DeleteByID(id int) error {
	result := config.DB.Delete(&model.User{}, id)
	if result.Error != nil {
		return result.Error
	}

	if result.RowsAffected == 0 {
		return fmt.Errorf("no user found with id: %d", id)
	}

	return nil
}

func (ur *UserRepository) UpdateFirebaseToken(userID uint, newToken string) (model.User, dto.HttpErrorDto) {
	var user model.User

	result := config.DB.First(&user, userID)
	if result.Error != nil {
		return model.User{}, dto.HttpErrorDto{Message: "User not found", Code: 404}
	}

	user.AndroidToken = newToken
	saveResult := config.DB.Save(&user)
	if saveResult.Error != nil {
		return model.User{}, dto.HttpErrorDto{Message: "Error while updating token", Code: 500}
	}

	return user, dto.HttpErrorDto{}
}
