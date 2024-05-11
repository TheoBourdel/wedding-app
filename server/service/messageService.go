// package service

// import (
// 	"api/model"

// 	"gorm.io/gorm"
// )

// type MessageService struct {
// 	DB *gorm.DB
// }

// func NewMessageService(db *gorm.DB) *MessageService {
// 	return &MessageService{DB: db}
// }

// func (svc *MessageService) SaveMessage(content string, roomID, userID uint) error {
// 	message := model.Message{
// 		Content: content,
// 		RoomID:  roomID,
// 		UserID:  userID,
// 	}
// 	return svc.DB.Create(&message).Error
// }

// func (svc *MessageService) GetMessagesByRoomID(roomID uint) ([]model.Message, error) {
// 	var messages []model.Message
// 	result := svc.DB.Where("room_id = ?", roomID).Find(&messages)
// 	if result.Error != nil {
// 		return nil, result.Error
// 	}
// 	return messages, nil
// }

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
	return &MessageService{
		Repo: repo,
	}
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
