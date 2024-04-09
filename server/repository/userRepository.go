package repository

import (
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

func (ur *UserRepository) Create(user model.User) model.User {

	result := config.DB.Create(&user)
	helper.ErrorPanic(result.Error)

	return user
}
