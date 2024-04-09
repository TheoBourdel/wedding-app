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
	Firstname string
	Lastname  string
	Email     string
	Password  string
}
