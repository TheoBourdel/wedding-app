package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type UserService struct {
	UserRepository repository.UserRepository
}

func (us *UserService) FindAll() []model.User {
	users := us.UserRepository.FindAll()

	return users
}

func (us *UserService) CreateUser(user model.User) (model.User, dto.HttpErrorDto) {
	user, error := us.UserRepository.Create(user)
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	return user, dto.HttpErrorDto{}
}

func (us *UserService) GetUser(id string) (model.User, dto.HttpErrorDto) {
	user, error := us.UserRepository.FindOneBy("id", id)
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	return user, dto.HttpErrorDto{}
}
