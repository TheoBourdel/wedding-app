package repository

import (
	"api/model"

	"api/config"

	"api/dto"

	"gorm.io/gorm"
)

type EstimateRepository struct {
	DB *gorm.DB
}

func (ur *EstimateRepository) CreateEstimate(estimate model.Estimate) (model.Estimate, dto.HttpErrorDto) {

	result := config.DB.Create(&estimate)

	if result.Error != nil {
		return model.Estimate{}, dto.HttpErrorDto{Message: "Error while creating estimate", Code: 500}
	}

	return estimate, dto.HttpErrorDto{}
}

func (ur *EstimateRepository) FindAllBy(field string, value any) ([]model.Estimate, dto.HttpErrorDto) {
	var estimates []model.Estimate

	result := config.DB.Where(field+" = ?", value).Find(&estimates)

	if result.Error != nil {
		return []model.Estimate{}, dto.HttpErrorDto{Message: "Error while fetching estimates", Code: 500}
	}

	return estimates, dto.HttpErrorDto{}
}

func (ur *EstimateRepository) FindOneBy(field string, value any) (model.Estimate, dto.HttpErrorDto) {
	var estimate model.Estimate

	result := config.DB.Preload("Provider").Preload("Client").Preload("Service").Where(field+" = ?", value).First(&estimate)

	if result.RowsAffected == 0 {
		return model.Estimate{}, dto.HttpErrorDto{Message: "Estimate not found", Code: 404}
	}

	if result.Error != nil {
		return model.Estimate{}, dto.HttpErrorDto{Message: "Error while fetching estimate", Code: 500}
	}

	return estimate, dto.HttpErrorDto{}
}

func (ur *EstimateRepository) UpdateEstimate(estimate model.Estimate) (model.Estimate, dto.HttpErrorDto) {
	//result := config.DB.Model(&model.Wedding{}).Where("id = ?", estimate.ID).Updates(estimate)

	result := config.DB.Save(&estimate)

	if result.Error != nil {
		return model.Estimate{}, dto.HttpErrorDto{Message: "Error while updating estimate", Code: 500}
	}

	return estimate, dto.HttpErrorDto{}
}

func (ur *EstimateRepository) DeleteEstimate(estimateId int) dto.HttpErrorDto {

	result := config.DB.Delete(&model.Estimate{}, estimateId)

	if result.RowsAffected == 0 {
		return dto.HttpErrorDto{Message: "Estimate not found", Code: 404}
	}

	if result.Error != nil {
		return dto.HttpErrorDto{Message: "Error while deleting estimate", Code: 500}
	}

	return dto.HttpErrorDto{}
}
