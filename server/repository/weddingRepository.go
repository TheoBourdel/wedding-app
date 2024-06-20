package repository

import (
	"api/config"
	"api/dto"
	"api/helper"
	"api/model"
	"fmt"

	"gorm.io/gorm"
)

type WeddingRepository struct {
	DB *gorm.DB
}

func (wr *WeddingRepository) FindAll() []model.Wedding {
	var weddings []model.Wedding

	result := config.DB.Find(&weddings)
	helper.ErrorPanic(result.Error)

	return weddings
}

func (wr *WeddingRepository) Create(wedding model.Wedding) (model.Wedding, dto.HttpErrorDto) {

	result := config.DB.Create(&wedding)
	if result.Error != nil {
		return model.Wedding{}, dto.HttpErrorDto{Message: "Error while creating wedding", Code: 500}
	}

	return wedding, dto.HttpErrorDto{}
}

func (wr *WeddingRepository) FindOneBy(field string, value string) (model.Wedding, dto.HttpErrorDto) {
	var wedding model.Wedding

	result := config.DB.Where(field+" = ?", value).First(&wedding)
	if result.RowsAffected == 0 {
		return model.Wedding{}, dto.HttpErrorDto{Message: "Wedding not found", Code: 404}
	}

	if result.Error != nil {
		return model.Wedding{}, dto.HttpErrorDto{Message: "Error while fetching wedding", Code: 500}
	}

	return wedding, dto.HttpErrorDto{}
}

func (wr *WeddingRepository) Delete(id uint64) error {
	result := config.DB.Delete(&model.Wedding{}, id)
	fmt.Println("WeddingService", result)

	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("no wedding found with ID: %d", id)
	}
	return nil
}

func (wr *WeddingRepository) Update(id uint64, wedding model.Wedding) (model.Wedding, error) {

	result := config.DB.Model(&model.Wedding{}).Where("id = ?", id).Updates(wedding)
	if result.Error != nil {
		return model.Wedding{}, result.Error
	}

	return wedding, nil
}

func (wr *WeddingRepository) FindByUserID(userID uint64) (model.Wedding, dto.HttpErrorDto) {
	var wedding model.Wedding

	result := config.DB.Preload("User", "id = ?", userID).First(&wedding)

	if result.RowsAffected == 0 {
		return model.Wedding{}, dto.HttpErrorDto{Message: "Wedding not found for this user", Code: 404}
	}

	if result.Error != nil {
		return model.Wedding{}, dto.HttpErrorDto{Message: "Error while fetching wedding", Code: 500}
	}

	return wedding, dto.HttpErrorDto{}
}

func (wr *WeddingRepository) RemoveUserFromWedding(userID int, weddingID int) dto.HttpErrorDto {
	var wedding model.Wedding
	// Find wedding
	result := config.DB.Where("id"+" = ?", weddingID).First(&wedding)
	if result.RowsAffected == 0 {
		return dto.HttpErrorDto{Message: "Wedding not found", Code: 404}
	}

	var user model.User
	if err := config.DB.First(&user, userID).Error; err != nil {
		fmt.Println("Error while finding user:", err)
		return dto.HttpErrorDto{Message: "Error while finding user", Code: 500}
	}

	if err := config.DB.Model(&wedding).Association("organizers").Delete(&user); err != nil {
		fmt.Println("Error while removing user from wedding:", err)
		return dto.HttpErrorDto{Message: "Error while removing user from wedding", Code: 500}
	}

	return dto.HttpErrorDto{}
}
