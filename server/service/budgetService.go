package service

import (
	"api/model"
	"gorm.io/gorm"
)

type BudgetService interface {
	Create(budget model.WeddingBudget) (model.WeddingBudget, error)
	FindByWeddingID(weddingID uint) ([]model.WeddingBudget, error)
	Update(id uint, budget model.WeddingBudget) error
	Delete(id uint) error
	GetTotalBudget(weddingID uint) (float64, error)
}

type budgetService struct {
	db *gorm.DB
}

func NewBudgetService(db *gorm.DB) BudgetService {
	return &budgetService{db}
}

func (s *budgetService) Create(budget model.WeddingBudget) (model.WeddingBudget, error) {
	if err := s.db.Create(&budget).Error; err != nil {
		return model.WeddingBudget{}, err
	}
	return budget, nil
}

func (s *budgetService) FindByWeddingID(weddingID uint) ([]model.WeddingBudget, error) {
	var budgets []model.WeddingBudget
	if err := s.db.Where("wedding_id = ?", weddingID).Find(&budgets).Error; err != nil {
		return nil, err
	}
	return budgets, nil
}

func (s *budgetService) Update(id uint, updatedBudget model.WeddingBudget) error {
	var budget model.WeddingBudget
	if err := s.db.First(&budget, id).Error; err != nil {
		return err
	}
	return s.db.Model(&budget).Updates(updatedBudget).Error
}

func (s *budgetService) Delete(id uint) error {
	return s.db.Delete(&model.WeddingBudget{}, id).Error
}

func (s *budgetService) GetTotalBudget(weddingID uint) (float64, error) {
    var budget float64
    err := s.db.Table("weddings").Select("budget").Where("id = ?", weddingID).Scan(&budget).Error
    return budget, err
}

