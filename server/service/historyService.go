package service

import (
	"gorm.io/gorm"
	"log"
	"fmt"
)

type HistoryService struct {
	DB *gorm.DB
}

type WeddingDetail struct {
	Name   string  `json:"name"`
	Budget float64 `json:"budget"`
}

func (s *HistoryService) WeddingsByYear(year int) ([]WeddingDetail, error) {
	if s.DB == nil {
    	return nil, fmt.Errorf("database connection is nil")
    }

	var weddings []WeddingDetail

	err := s.DB.Table("weddings").
		Select("name, budget").
		Where("EXTRACT(YEAR FROM created_at) = ?", year).
		Scan(&weddings).Error
    if err != nil {
    		log.Printf("Error fetching weddings: %v", err)
    		return nil, err
    }

    log.Printf("Fetched weddings: %v", weddings)
	if err != nil {
		return nil, err
	}

	return weddings, nil
}
