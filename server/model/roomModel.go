package model

import (
	"gorm.io/gorm"
)

type Room struct {
	gorm.Model
	RoomName string
	Messages []Message
}

type RoomRes struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type CreateRoomReq struct {
	ID   string `json:"id"`
	Name string `json:"name"`
}

type SessionChatRes struct {
	ID     string `json:"id"`
	UserId string `json:"userId"`
}
