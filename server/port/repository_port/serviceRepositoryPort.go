package repository_port

import (
	"api/dto"
	"api/model"
)

type ServiceRepositoryInterface interface {
	FindAll() ([]model.Service, error)
	FindOneBy(field string, value string) (model.Service, dto.HttpErrorDto)
	Create(user model.Service) (model.Service, dto.HttpErrorDto)
	Delete(id uint64) error
	Update(id uint64, service model.Service) error
}