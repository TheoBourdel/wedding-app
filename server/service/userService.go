package service

import (
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
