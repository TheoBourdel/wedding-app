package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"api/utils"
)

type EstimateService struct {
	EstimateRepository repository.EstimateRepository
	UserRepository     repository.UserRepository
	PdfGenerator       utils.PdfGenerator
}

func (es *EstimateService) UpdateEstimate(userId int, estimateId int, body model.Estimate) (model.Estimate, dto.HttpErrorDto) {

	estimate, error := es.EstimateRepository.FindOneBy("id", estimateId)
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	_, error = es.UserRepository.FindOneBy("id", userId)
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	if estimate.ClientID != uint(userId) && estimate.ProviderID != uint(userId) {
		return model.Estimate{}, dto.HttpErrorDto{Message: "Unthorized", Code: 403}
	}

	estimate, error = es.EstimateRepository.UpdateEstimate(body)
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	updatedEstimate, error := es.EstimateRepository.FindOneBy("id", estimateId)
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	return updatedEstimate, error
}

func (es *EstimateService) DeleteEstimate(userId int, estimateId int) dto.HttpErrorDto {

	estimate, error := es.EstimateRepository.FindOneBy("id", estimateId)
	if error != (dto.HttpErrorDto{}) {
		return error
	}

	_, error = es.UserRepository.FindOneBy("id", userId)
	if error != (dto.HttpErrorDto{}) {
		return error
	}

	if estimate.ClientID != uint(userId) && estimate.ProviderID != uint(userId) {
		return dto.HttpErrorDto{Message: "Unthorized", Code: 403}
	}

	error = es.EstimateRepository.DeleteEstimate(estimateId)
	if error != (dto.HttpErrorDto{}) {
		return error
	}

	return dto.HttpErrorDto{}
}

func (es *EstimateService) GetEstimateByID(estimateID uint) (model.Estimate, error) {
	estimate, error := es.EstimateRepository.FindOneBy("id", estimateID)
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}
	return estimate, nil
}
