package service

import (
   "gorm.io/gorm"
)

type PaymentSettings struct {
	ID               uint `gorm:"primary_key"`
	IsPaymentEnabled bool `json:"is_payment_enabled"`
}

type PaymentService struct {
	DB *gorm.DB
}

func (ps *PaymentService) GetPaymentStatus() (PaymentSettings, error) {
	var settings PaymentSettings
	if err := ps.DB.First(&settings).Error; err != nil {
		return settings, err
	}
	return settings, nil
}

func (ps *PaymentService) UpdatePaymentStatus(newStatus PaymentSettings) error {
	var settings PaymentSettings
	if err := ps.DB.First(&settings).Error; err != nil {
		return err
	}
	settings.IsPaymentEnabled = newStatus.IsPaymentEnabled
	if err := ps.DB.Save(&settings).Error; err != nil {
		return err
	}
	return nil
}
