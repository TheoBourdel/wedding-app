package service

import (
	"api/model"
	"api/repository"

	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	UserRepository repository.UserRepository
}

func (as *AuthService) SignUp(body model.User) model.User {
	hash, err := bcrypt.GenerateFromPassword([]byte(body.Password), bcrypt.DefaultCost)
	// change error handling
	if err != nil {
		return model.User{}
	}

	user := model.User{
		Firstname: body.Firstname,
		Lastname:  body.Lastname,
		Email:     body.Email,
		Password:  string(hash),
	}

	result := as.UserRepository.Create(user)

	return result
}

func (as *AuthService) SignIn(body model.User) {
	// add implementation
}
