package model

import (
	"gorm.io/gorm"
)

type Wedding struct {
	gorm.Model
	Name         string
	Description  string
	ProfileImage string
	Address      string
	Phone        string
	Email        string
	Budget       float64
	User         []User `gorm:"many2many:organizer;"`
}
