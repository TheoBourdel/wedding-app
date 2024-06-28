package model

import (
	"time"
)

type Category struct {
    ID        uint       `json:"id" gorm:"primary_key"`
    Name      string     `json:"name"`
    CreatedAt time.Time  `json:"created_at"`
    UpdatedAt time.Time  `json:"updated_at"`
    DeletedAt *time.Time `json:"deleted_at,omitempty"`
}