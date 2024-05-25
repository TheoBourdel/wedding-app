package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"fmt"
)

type MessageService struct {
	Repo *repository.MessageRepository
}

func NewMessageService(repo *repository.MessageRepository) *MessageService {
	return &MessageService{Repo: repo}
}

func (svc *MessageService) SaveMessage(message model.Message) (model.Message, dto.HttpErrorDto) {
	createdMessage, err := svc.Repo.SaveMessage(message)

	if err.Code != 0 {
		return model.Message{}, err
	}

	return createdMessage, dto.HttpErrorDto{}
}

func (svc *MessageService) FindByID(roomID uint) ([]model.Message, error) {

	messages, err := svc.Repo.GetMessagesByRoomID(roomID)
	if err.Code != 0 {
		return nil, fmt.Errorf("messages not found: %s", err.Message) // Retourne nil pour le tableau en cas d'erreur
	}

	return messages, nil
}
