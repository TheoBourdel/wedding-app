package model

import (
	"gorm.io/gorm"
)

type Service struct {
    gorm.Model
    Name        string
    Description string
    ProfileImage string
    Localisation string
    Mail string
    Phone string
    Price float64
    UserID      uint
    User        User `gorm:"foreignKey:UserID"`
}