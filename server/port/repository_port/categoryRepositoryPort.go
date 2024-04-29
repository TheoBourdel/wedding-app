package repository_port

import (
	"api/dto"
	"api/model"
)

type CategoryRepositoryInterface interface {
	FindAll() ([]model.Category, error)
	FindOneBy(field string, value string) (model.Category, dto.HttpErrorDto)
	Create(user model.Category) (model.Category, dto.HttpErrorDto)
	Delete(id uint64) error
	Update(id uint64, category model.Category) error
}