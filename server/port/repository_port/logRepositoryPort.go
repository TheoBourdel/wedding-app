package repository_port

import (
	"api/dto"
	"api/model"
)

type MessageRepositoryInterface interface {
	FindAll() ([]model.log, error)
	Create(user model.log) (model.log, dto.HttpErrorDto)
}
