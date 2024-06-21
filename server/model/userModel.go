package model

import (
	"gorm.io/gorm"
)

type Role string

const (
	Admin    Role = "admin"
	Provider Role = "provider"
	Marry    Role = "marry"
)

type User struct {
	gorm.Model
	Firstname    string `json:"Firstname"`
	Lastname     string
	Email        string `json:"Email"`
	Password     string
	AndroidToken string
	Role         Role
	Weddings     []Wedding  `gorm:"many2many:organizer;"`
	Estimates    []Estimate `gorm:"foreignKey:ClientID"`
}
