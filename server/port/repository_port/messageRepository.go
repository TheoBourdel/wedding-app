package repository_port

import (
	"api/dto"
	"api/model"
)

type MessageRepositoryInterface interface {
	FindAll() ([]model.Message, error)
	FindOneBy(field string, value string) (model.Message, dto.HttpErrorDto)
	Create(user model.Message) (model.Message, dto.HttpErrorDto)
	Delete(id uint64) error
	Update(id uint64, Message model.Message) error
}
