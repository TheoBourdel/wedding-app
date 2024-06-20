package repository

import (
	"api/dto"
	"api/helper"
	"api/model"

	"api/config"

	"gorm.io/gorm"
)

type UserRepository struct {
	DB *gorm.DB
}

func (ur *UserRepository) FindAll() []model.User {
	var users []model.User

	result := config.DB.Find(&users)
	helper.ErrorPanic(result.Error)

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

	result := config.DB.Joins("JOIN organizer ON users.id = organizer.user_id").Where("organizer.wedding_id = ?", weddingID).Find(&users)
	if result.Error != nil {
		return []model.User{}, dto.HttpErrorDto{Message: "Error while fetching users", Code: 500}
	}

	return users, dto.HttpErrorDto{}
}
