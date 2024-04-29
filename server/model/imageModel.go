package model

import (
	"gorm.io/gorm"
)

type Image struct {
    gorm.Model
    Path        string
    ServiceID      uint
    Service        Service `gorm:"foreignKey:ServiceID"`
}