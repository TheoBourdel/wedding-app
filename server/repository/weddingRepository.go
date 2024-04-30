package repository

import (
	"api/config"
	"api/dto"
	"api/helper"
	"api/model"
	"fmt"
	"strconv"

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

	result := config.DB.Where(field+" = ?", value).Preload("User").First(&wedding)
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

func (wr *WeddingRepository) Update(id uint64, updatedWedding model.Wedding) (model.Wedding, error) {
	existingWedding, err := wr.FindOneBy("id", strconv.FormatUint(id, 10))
	if err.Code == 404 {
		return model.Wedding{}, fmt.Errorf("wedding not found with ID: %d", id)
	} else if err.Code != 0 {
		return model.Wedding{}, fmt.Errorf("error fetching wedding: %s", err.Message)
	}

	result := config.DB.Model(&existingWedding).Updates(updatedWedding)
	if result.Error != nil {
		return model.Wedding{}, result.Error
	}

	// Renvoyer le mariage mis à jour après la mise à jour dans la base de données
	return existingWedding, nil
}

func (wr *WeddingRepository) FindByUserID(userID uint64) (model.Wedding, dto.HttpErrorDto) {
	var wedding model.Wedding

	result := config.DB.Where("user_id = ?", userID).First(&wedding)

	if result.RowsAffected == 0 {
		return model.Wedding{}, dto.HttpErrorDto{Message: "Wedding not found for this user", Code: 404}
	}

	if result.Error != nil {
		return model.Wedding{}, dto.HttpErrorDto{Message: "Error while fetching wedding", Code: 500}
	}

	return wedding, dto.HttpErrorDto{}
}
