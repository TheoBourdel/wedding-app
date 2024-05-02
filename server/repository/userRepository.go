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

// func (wr *UserRepository) Update(id uint64, updatedUser model.User) (model.User, error) {

// 	existingUser, err := wr.FindOneBy("id", strconv.FormatUint(id, 10))

// 	if err.Code == 404 {

// 		return model.User{}, fmt.Errorf("wedding not found with ID: %d", id)
// 	} else if err.Code != 0 {
// 		return model.User{}, fmt.Errorf("error fetching wedding: %s", err.Message)
// 	}

// 	result := config.DB.Model(&existingUser).Updates(updatedUser)
// 	if result.Error != nil {
// 		return model.User{}, result.Error
// 	}

// 	return existingUser, nil
// }

func (ur *UserRepository) FindOneBy(field string, value string) (model.User, dto.HttpErrorDto) {
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
