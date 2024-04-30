package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"fmt"
	"strconv"
)

type WeddingService struct {
	WeddingRepository repository.WeddingRepository
	UserRepository    repository.UserRepository
}

func (ws *WeddingService) FindAll() []model.Wedding {
	weddings := ws.WeddingRepository.FindAll()

	return weddings
}

func (ws *WeddingService) Create(wedding model.Wedding) (model.Wedding, dto.HttpErrorDto) {

	_, err := ws.UserRepository.FindOneBy("id", strconv.Itoa(int(wedding.UserID)))

	if err.Code != 0 {
		return model.Wedding{}, err
	}

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

// func (ws *WeddingService) Update(id uint64, updatedWedding model.Wedding) error {
// 	_, findErr := ws.WeddingRepository.FindOneBy("id", strconv.FormatUint(id, 10))
// 	if findErr.Code == 404 {
// 		return fmt.Errorf("wedding not found with ID: %d", id)
// 	} else if findErr.Code != 0 {
// 		return fmt.Errorf("error fetching wedding: %s", findErr.Message)
// 	}

// 	updatedWedding, updateErr := ws.WeddingRepository.Update(id, updatedWedding)

// 	if updateErr != nil {
// 		return fmt.Errorf("error updating wedding: %s", updateErr.Error())
// 	}

// 	return updatedWedding, nil
// }

func (ws *WeddingService) Update(id uint64, updatedWedding model.Wedding) (model.Wedding, error) {
	_, findErr := ws.WeddingRepository.FindOneBy("id", strconv.FormatUint(id, 10))
	if findErr.Code == 404 {
		return model.Wedding{}, fmt.Errorf("wedding not found with ID: %d", id)
	} else if findErr.Code != 0 {
		return model.Wedding{}, fmt.Errorf("error fetching wedding: %s", findErr.Message)
	}

	updatedWedding, updateErr := ws.WeddingRepository.Update(id, updatedWedding)
	if updateErr != nil {
		return model.Wedding{}, fmt.Errorf("error updating wedding: %s")
	}

	return updatedWedding, nil
}

func (ws *WeddingService) FindByUserID(userID uint64) (model.Wedding, error) {
	// Utilisez l'ID de l'utilisateur pour rechercher le mariage associé
	wedding, err := ws.WeddingRepository.FindByUserID(userID)

	if err.Code != 0 {
		return model.Wedding{}, fmt.Errorf("wedding not found: %s", err.Message)
	}

	return wedding, nil
}
