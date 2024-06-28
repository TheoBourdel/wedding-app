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
	ID      string `json:"id"`
	Name    string `json:"name"`
	UserIDs []uint `json:"user_ids"`
}

type SessionChatRes struct {
	ID     string `json:"id"`
	UserId string `json:"userId"`
}

type RoomWithUsers struct {
	ID        uint   `json:"id"`
	RoomName  string `json:"room_name"`
	RoomId    string `json:"room_id"`
	UserID    uint   `json:"user_id"`
	Firstname string `json:"firstname"`
	Lastname  string `json:"lastname"`
	Email     string `json:"email"`
}
