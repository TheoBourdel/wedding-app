package service

import (
	"gorm.io/gorm"
)

type PaymentSettings struct {
	ID               uint `gorm:"primaryKey"`
	IsPaymentEnabled bool `json:"is_payment_enabled"`
}

type PaymentService struct {
	DB *gorm.DB
}

func (ps *PaymentService) EnsureDefaultPaymentSetting() error {
	var count int64
	if err := ps.DB.Model(&PaymentSettings{}).Count(&count).Error; err != nil {
		return err
	}
	if count == 0 {
		defaultSetting := PaymentSettings{IsPaymentEnabled: false}
		if err := ps.DB.Create(&defaultSetting).Error; err != nil {
			return err
		}
	}
	return nil
}

func (ps *PaymentService) GetPaymentStatus() (PaymentSettings, error) {
	if err := ps.EnsureDefaultPaymentSetting(); err != nil {
		return PaymentSettings{}, err
	}
	var settings PaymentSettings
	if err := ps.DB.First(&settings).Error; err != nil {
		return settings, err
	}
	return settings, nil
}

func (ps *PaymentService) UpdatePaymentStatus(newStatus PaymentSettings) error {
	if err := ps.EnsureDefaultPaymentSetting(); err != nil {
		return err
	}
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
