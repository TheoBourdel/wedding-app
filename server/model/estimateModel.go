package model

import (
	"gorm.io/gorm"
)

type Estimate struct {
	gorm.Model
	Status     string
	Content    string
	Price      float64
	ProviderID uint
	ClientID   uint
	Provider   User `gorm:"foreignKey:ProviderID"`
	Client     User `gorm:"foreignKey:ClientID"`
	ServiceID  uint
	Service    Service `gorm:"foreignKey:ServiceID"`
}
