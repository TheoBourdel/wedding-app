package service

import (
	"api/model"
	"api/repository"
)

type LogService struct {
	logRepository *repository.LogRepository
}

func NewLogService(logRepository *repository.LogRepository) *LogService {
	return &LogService{logRepository: logRepository}
}

func (s *LogService) Create(log model.Log) (model.Log, error) {
	err := s.logRepository.Create(&log)
	if err != nil {
		return model.Log{}, err
	}
	return log, nil
}

func (s *LogService) GetAll() ([]model.Log, error) {
	return s.logRepository.GetAll()
}
