package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"fmt"
)

type UserService struct {
	UserRepository repository.UserRepository
}


func (us *UserService) FindAll(page int, pageSize int, query string) []model.User {
	users := us.UserRepository.FindAll(page, pageSize, query)
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


func (us *UserService) DeleteUserByID(id int) error {
	err := us.UserRepository.DeleteByID(id)
	if err != nil {
		return fmt.Errorf("failed to delete user: %v", err)
	}
	return nil
}
