package service

import (
	"api/model"
	"gorm.io/gorm"
	"time"
)

type StatisticsService struct {
	DB *gorm.DB
}
type MonthlyRevenue struct {
    Year    int     `json:"year"`
	Month   int     `json:"month"`
	Revenue float64 `json:"revenue"`
}

func (s *StatisticsService) TotalProviders() (int64, error) {
	var count int64
	err := s.DB.Model(&model.User{}).Where("role = ?", model.Provider).Count(&count).Error
	return count, err
}

func (s *StatisticsService) TotalWeddings() (int64, error) {
	var count int64
	err := s.DB.Model(&model.Wedding{}).Count(&count).Error
	return count, err
}

func (s *StatisticsService) TotalGuests() (int64, error) {
	var count int64
	startOfMonth := time.Now().UTC().Truncate(time.Hour * 24).AddDate(0, 0, -time.Now().Day()+1)
	endOfMonth := startOfMonth.AddDate(0, 1, 0)
	err := s.DB.Model(&model.User{}).
		Where("created_at >= ? AND created_at < ?", startOfMonth, endOfMonth).
		Count(&count).Error
	return count, err
}

func (s *StatisticsService) AverageBudget() (float64, error) {
	var average float64
	err := s.DB.Model(&model.Wedding{}).Select("AVG(budget)").Scan(&average).Error
	return average, err
}


func (s *StatisticsService) MonthlyRevenue(year int) ([]MonthlyRevenue, error) {
	var revenues []MonthlyRevenue

	err := s.DB.Table("weddings").
    		Select("EXTRACT(YEAR FROM created_at) as year, EXTRACT(MONTH FROM created_at) as month, SUM(budget) as revenue").
    		Where("EXTRACT(YEAR FROM created_at) = ?", year).
    		Group("EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at)").
    		Order("EXTRACT(YEAR FROM created_at), EXTRACT(MONTH FROM created_at)").
    		Scan(&revenues).Error

	if err != nil {
		return nil, err
	}

	return revenues, nil
}