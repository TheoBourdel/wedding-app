package service

import (
	"gorm.io/gorm"
)

type HistoryService struct {
	DB *gorm.DB
}

type WeddingDetail struct {
	Name   string  `json:"name"`
	Budget float64 `json:"budget"`
}

func (s *HistoryService) WeddingsByYear(year int) ([]WeddingDetail, error) {
	var weddings []WeddingDetail

	err := s.DB.Table("weddings").
		Select("name, budget").
		Where("EXTRACT(YEAR FROM created_at) = ?", year).
		Scan(&weddings).Error

	if err != nil {
		return nil, err
	}

	return weddings, nil
}
