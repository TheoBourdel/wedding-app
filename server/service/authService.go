package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"os"
	"time"

	jwt "github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type AuthService struct {
	UserRepository repository.UserRepository
}

func (as *AuthService) SignUp(body model.User) (model.User, dto.HttpErrorDto) {
	hash, err := bcrypt.GenerateFromPassword([]byte(body.Password), bcrypt.DefaultCost)
	if err != nil {
		return model.User{}, dto.HttpErrorDto{Message: "Error while hashing password", Code: 500}
	}

	if body.Role != "provider" && body.Role != "marry" {
		return model.User{}, dto.HttpErrorDto{Message: "Invalid role", Code: 400}
	}

	user := model.User{
		Firstname: body.Firstname,
		Lastname:  body.Lastname,
		Email:     body.Email,
		Password:  string(hash),
		Role:      body.Role,
	}

	user, error := as.UserRepository.Create(user)
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	return user, dto.HttpErrorDto{}
}

func (as *AuthService) SignIn(body dto.SignInDto) (string, dto.HttpErrorDto) {
	var user model.User
	var error dto.HttpErrorDto

	user, error = as.UserRepository.FindOneBy("email", body.Email)
	if error != (dto.HttpErrorDto{}) {
		return "", error
	}

	err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(body.Password))
	if err != nil {
		return "", dto.HttpErrorDto{Message: "Invalid password", Code: 401}
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub":  user.ID,
		"exp":  time.Now().Add(time.Hour * 24 * 30).Unix(),
		"role": user.Role,
	})

	tokenString, err := token.SignedString([]byte(os.Getenv("JWT_SECRET")))
	if err != nil {
		return "", dto.HttpErrorDto{Message: "Error while generating token", Code: 500}
	}

	return tokenString, dto.HttpErrorDto{}
}
