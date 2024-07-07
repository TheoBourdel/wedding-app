package model

import (
	"gorm.io/gorm"
)

type Wedding struct {
	gorm.Model
	Address string
	Phone   string
	Email   string
	Budget  float64
	Date    string
	User    []User `gorm:"many2many:organizers;"`
}
