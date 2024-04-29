package repository_port

import (
	"api/dto"
	"api/model"
)

type ImageRepositoryInterface interface {
	FindAll() ([]model.Image, error)
	FindOneBy(field string, value string) (model.Image, dto.HttpErrorDto)
	Create(user model.Image) (model.Image, dto.HttpErrorDto)
	Delete(id uint64) error
	Update(id uint64, image model.Image) error
}