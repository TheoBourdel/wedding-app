package model

import (
	"time"

	"gorm.io/gorm"
)

type RoomParticipant struct {
	gorm.Model
	RoomID   uint
	Room     Room `gorm:"foreignKey:RoomID"`
	UserID   uint
	User     User `gorm:"foreignKey:UserID"`
	JoinedAt time.Time
}
