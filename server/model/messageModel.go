package model

import (
	"time"

	"gorm.io/gorm"
)

type Message struct {
	gorm.Model
	RoomID    uint
	Room      Room `gorm:"foreignKey:RoomID"`
	UserID    uint
	User      User `gorm:"foreignKey:UserID"`
	Content   string
	CreatedAt time.Time
}
