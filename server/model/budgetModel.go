package model

import (
	"time"
)

type WeddingBudget struct {
	ID         uint      `json:"id" gorm:"primary_key;autoIncrement"`
	WeddingID  uint      `json:"wedding_id"`
	CategoryID uint      `json:"category_id"`
	Amount     float64   `json:"amount"`
	CreatedAt  time.Time `json:"created_at"`
	UpdatedAt  time.Time `json:"updated_at"`
	DeletedAt  time.Time `json:"deleted_at,omitempty"`
}
