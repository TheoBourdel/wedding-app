package model

import (
	"gorm.io/gorm"
)

type Wedding struct {
    gorm.Model
    Name        string
    Description string
    ProfileImage string
    Address     string
    Phone       string
    Email       string
    Budget      float64
    UserID      uint 
    User        User `gorm:"foreignKey:UserID"`
}
