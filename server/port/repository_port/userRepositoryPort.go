package repository_port

import (
	"api/dto"
	"api/model"
)

type UserRepositoryInterface interface {
	FindAll() ([]model.User, error)
	FindOneBy(field string, value string) (model.User, dto.HttpErrorDto)
	Create(user model.User) (model.User, dto.HttpErrorDto)
}
