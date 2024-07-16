package repository

import (
	"api/model"
	"gorm.io/gorm"
)

type LogRepository struct {
	DB *gorm.DB
}

func NewLogRepository(db *gorm.DB) *LogRepository {
	return &LogRepository{DB: db}
}

func (lr *LogRepository) Create(log *model.Log) error {
	return lr.DB.Create(log).Error
}

func (lr *LogRepository) GetAll() ([]model.Log, error) {
	var logs []model.Log
	result := lr.DB.Find(&logs)
	if result.Error != nil {
		return nil, result.Error
	}
	return logs, nil
}
