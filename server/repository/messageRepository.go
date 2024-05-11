package repository

import (
	"api/config"
	"api/dto"
	"api/model"

	"gorm.io/gorm"
)

type MessageRepository struct {
	DB *gorm.DB
}

func NewMessageRepository(db *gorm.DB) *MessageRepository {
	return &MessageRepository{DB: db}
}

func (repo *MessageRepository) SaveMessage(message model.Message) (model.Message, dto.HttpErrorDto) {
	result := repo.DB.Create(&message).Error

	if result != nil && result.Error != nil {
		return model.Message{}, dto.HttpErrorDto{Message: "Error while creating image", Code: 500}
	}

	return message, dto.HttpErrorDto{}
}

func (wr *MessageRepository) GetMessagesByRoomID(roomID uint) ([]model.Message, dto.HttpErrorDto) {

	var messages []model.Message
	result := config.DB.Where("room_id = ?", roomID).Find(&messages)

	if result.Error != nil {
		return nil, dto.HttpErrorDto{Message: "Error while fetching messages", Code: 500}
	}

	return messages, dto.HttpErrorDto{}
}
