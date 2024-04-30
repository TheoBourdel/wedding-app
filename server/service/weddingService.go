package service

import (
	"api/dto"
	"api/mailer"
	"api/model"
	"api/repository"
	"api/utils"
	"fmt"
	"strconv"

	"golang.org/x/crypto/bcrypt"
)

type WeddingService struct {
	WeddingRepository repository.WeddingRepository
	UserRepository    repository.UserRepository
	PasswordGenerator utils.PasswordGenerator
	Mailer            mailer.Mailer
}

func (ws *WeddingService) FindAll() []model.Wedding {
	weddings := ws.WeddingRepository.FindAll()

	return weddings
}

func (ws *WeddingService) Create(wedding model.Wedding) (model.Wedding, dto.HttpErrorDto) {

	createdWedding, err := ws.WeddingRepository.Create(wedding)
	if err.Code != 0 {
		return model.Wedding{}, err
	}

	return createdWedding, dto.HttpErrorDto{}
}

func (ws *WeddingService) FindByID(id uint64) (model.Wedding, error) {
	wedding, err := ws.WeddingRepository.FindOneBy("id", strconv.FormatUint(id, 10))
	if err.Code != 0 {
		return model.Wedding{}, fmt.Errorf("wedding not found: %s", err.Message)
	}

	return wedding, nil
}

func (ws *WeddingService) Delete(id uint64) error {

	_, findErr := ws.WeddingRepository.FindOneBy("id", strconv.FormatUint(id, 10))

	if findErr.Code == 404 {
		return fmt.Errorf("wedding not found with ID: %d", id)
	} else if findErr.Code != 0 {
		return fmt.Errorf("error fetching wedding: %s", findErr.Message)
	}

	deleteErr := ws.WeddingRepository.Delete(id)
	fmt.Println("WeddingService", deleteErr)

	if deleteErr != nil {
		return fmt.Errorf("error deleting wedding: %s", deleteErr.Error())
	}
	return nil
}

func (ws *WeddingService) Update(id uint64, updatedWedding model.Wedding) error {
	_, findErr := ws.WeddingRepository.FindOneBy("id", strconv.FormatUint(id, 10))
	if findErr.Code == 404 {
		return fmt.Errorf("wedding not found with ID: %d", id)
	} else if findErr.Code != 0 {
		return fmt.Errorf("error fetching wedding: %s", findErr.Message)
	}

	updateErr := ws.WeddingRepository.Update(id, updatedWedding)
	if updateErr != nil {
		return fmt.Errorf("error updating wedding: %s", updateErr.Error())
	}

	return nil
}

func (ws *WeddingService) AddWeddingOrganizer(weddingID uint64, user model.User) (model.User, dto.HttpErrorDto) {

	// Find the wedding by ID
	wedding, error := ws.WeddingRepository.FindOneBy("id", strconv.FormatUint(weddingID, 10))
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	// Generate a random password for the user
	password := ws.PasswordGenerator.GenerateRandomPassword(8)
	hash, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return model.User{}, dto.HttpErrorDto{Message: "Error while hashing password", Code: 500}
	}

	// Create the user
	organizer := model.User{
		Firstname: user.Firstname,
		Email:     user.Email,
		Password:  string(hash),
	}

	// Add the user to the wedding's organizers
	organizer.Weddings = append(user.Weddings, wedding)

	organizer, error = ws.UserRepository.Create(organizer)
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	// Add the user to the wedding's organizers
	wedding.User = append(wedding.User, organizer)

	subject := "Invitation à collaborer à un mariage"

	// Send an email to the user
	ws.Mailer.SendMail(
		organizer.Email,
		subject,
		"./mailer/html/addOrganizer.html",
		struct {
			Password string
			Email    string
		}{Password: password, Email: organizer.Email},
	)

	return organizer, dto.HttpErrorDto{}

}
