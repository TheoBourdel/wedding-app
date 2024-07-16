package model

import (
    "gorm.io/gorm"
)

type Favorite struct {
    gorm.Model
    UserID   uint
    User User `gorm:"foreignKey:UserID"`
    ServiceID    uint
    Service Service `gorm:"foreignKey:ServiceID"`
}
