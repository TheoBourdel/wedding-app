package service

import (
	"api/config"
	"api/dto"
	"api/mailer"
	"api/model"
	"api/repository"
	"api/utils"
	"fmt"
	"strconv"

	"gorm.io/gorm"

	"golang.org/x/crypto/bcrypt"
)

type WeddingService struct {
	WeddingRepository repository.WeddingRepository
	UserRepository    repository.UserRepository
	PasswordGenerator utils.PasswordGenerator
	Mailer            mailer.Mailer
	DB                *gorm.DB
}

func (ws *WeddingService) FindAll() []model.Wedding {
	weddings := ws.WeddingRepository.FindAll()

	return weddings
}

func (ws *WeddingService) Create(userId uint64, wedding model.Wedding) (model.Wedding, dto.HttpErrorDto) {
	user, err := ws.UserRepository.FindOneBy("id", strconv.FormatUint(userId, 10))
	if err != (dto.HttpErrorDto{}) {
		return model.Wedding{}, err
	}

	if user.ID == 0 {
		return model.Wedding{}, dto.HttpErrorDto{Code: 404, Message: "User not found"}
	}

	tx := config.DB.Begin()

	// Création du mariage dans la base de données
	createdWedding, error := ws.WeddingRepository.Create(wedding)
	if error != (dto.HttpErrorDto{}) {
		tx.Rollback()
		return model.Wedding{}, dto.HttpErrorDto{Code: 404, Message: "Problem creating wedding"}
	}

	// Ajout du mariage à l'utilisateur et sauvegarde dans la base de données
	user.Weddings = append(user.Weddings, createdWedding)
	if saveErr := tx.Save(&user).Error; saveErr != nil {
		tx.Rollback()
		fmt.Printf("Failed to save user: %v", saveErr)
		return model.Wedding{}, dto.HttpErrorDto{Code: 500, Message: "Failed to save user"}
	}

	// Validation de la transaction
	if err := tx.Commit().Error; err != nil {
		fmt.Printf("Failed to commit transaction: %v", err)
		return model.Wedding{}, dto.HttpErrorDto{Code: 500, Message: "Failed to commit transaction"}
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
	isSended := ws.Mailer.SendMail(
		organizer.Email,
		subject,
		"./mailer/html/addOrganizer.html",
		struct {
			Password string
			Email    string
		}{Password: password, Email: organizer.Email},
	)
	if !isSended {
		return model.User{}, dto.HttpErrorDto{Message: "Error while sending email", Code: 500}
	}

	return organizer, dto.HttpErrorDto{}
}

func (ws *WeddingService) Update(id uint64, wedding model.Wedding) (model.Wedding, error) {
	_, findErr := ws.WeddingRepository.FindOneBy("id", strconv.FormatUint(id, 10))
	if findErr.Code == 404 {
		return model.Wedding{}, fmt.Errorf("wedding not found with ID: %d", id)
	} else if findErr.Code != 0 {
		return model.Wedding{}, fmt.Errorf("error fetching wedding: %s", findErr.Message)
	}

	updatedWedding, updateErr := ws.WeddingRepository.Update(id, wedding)
	if updateErr != nil {
		return model.Wedding{}, fmt.Errorf("error updating wedding: %s")
	}

	return updatedWedding, nil
}

func (ws *WeddingService) FindByUserID(userID uint64) ([]model.Wedding, error) {
	//wedding, err := ws.WeddingRepository.FindByUserID(userID)
	user, err := ws.UserRepository.FindOneBy("id", strconv.FormatUint(userID, 10))
	wedding := user.Weddings

	if err.Code != 0 {
		if err.Code == 404 {
			return []model.Wedding{}, fmt.Errorf("wedding not found for user ID %d", userID)
		}
		return []model.Wedding{}, fmt.Errorf("error finding wedding for user ID %d: %s", userID, err.Message)
	}

	return wedding, nil
}
