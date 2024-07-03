package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type OrganizerService struct {
	UserRepository    repository.UserRepository
	WeddingRepository repository.WeddingRepository
}

func (os *OrganizerService) GetOrganizers(weddingId string) ([]model.User, dto.HttpErrorDto) {
	wedding, err := os.WeddingRepository.FindOneBy("id", weddingId)
	if err != (dto.HttpErrorDto{}) {
		return []model.User{}, err
	}

	organizers, err := os.UserRepository.FindAllByWeddingID(wedding.ID)
	if err != (dto.HttpErrorDto{}) {
		return []model.User{}, err
	}

	return organizers, dto.HttpErrorDto{}
}

func (os *OrganizerService) DeleteOrganizer(weddingId string, organizerId string) dto.HttpErrorDto {
	wedding, err := os.WeddingRepository.FindOneBy("id", weddingId)
	if err != (dto.HttpErrorDto{}) {
		return err
	}

	organizer, err := os.UserRepository.FindOneBy("id", organizerId)
	if err != (dto.HttpErrorDto{}) {
		return err
	}
	if organizer.Role == "marry" || organizer.Role == "provider" {
		return dto.HttpErrorDto{Message: "Can't remove this user from the wedding"}
	}

	err = os.WeddingRepository.RemoveUserFromWedding(int(organizer.ID), int(wedding.ID))
	if err != (dto.HttpErrorDto{}) {
		return err
	}

	return dto.HttpErrorDto{}
}
