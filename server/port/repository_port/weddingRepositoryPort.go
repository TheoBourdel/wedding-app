package repository_port

import (
	"api/dto"
	"api/model"
)

type WeddingRepositoryInterface interface {
	FindAll() ([]model.Wedding, error)
	FindOneBy(field string, value string) (model.Wedding, dto.HttpErrorDto)
	Create(user model.Wedding) (model.Wedding, dto.HttpErrorDto)
	Delete(id uint64) error
	Update(id uint64, wedding model.Wedding) error
	FindByUserID(id uint64, wedding model.Wedding) error
	RemoveUserFromWedding(weddingID uint64, userID uint64) dto.HttpErrorDto
}
