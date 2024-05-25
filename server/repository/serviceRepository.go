package repository

import (
	"api/config"
	"api/dto"
	"api/helper"
	"api/model"
	"fmt"
	"strconv"

	"gorm.io/gorm"
)

type ServiceRepository struct {
	DB *gorm.DB
}

func (r *ServiceRepository) FindImagesByServiceID(serviceID uint64) ([]model.Image, dto.HttpErrorDto) {
    var images []model.Image
    result := r.DB.Where("service_id = ?", serviceID).Find(&images)
    if result.Error != nil {
        return nil, dto.HttpErrorDto{Message: "Error fetching images", Code: 500}
    }
    if result.RowsAffected == 0 {
        return nil, dto.HttpErrorDto{Message: "No images found for this service", Code: 404}
    }
    return images, dto.HttpErrorDto{}
}

func (wr *ServiceRepository) FindAll() []model.Service {
	var services []model.Service

	result := config.DB.Find(&services)
	helper.ErrorPanic(result.Error)

	return services
}

func (wr *ServiceRepository) Create(service model.Service) (model.Service, dto.HttpErrorDto) {
	result := config.DB.Create(&service)
	if result.Error != nil {
		return model.Service{}, dto.HttpErrorDto{Message: "Error while creating service", Code: 500}
	}

	return service, dto.HttpErrorDto{}
}

func (wr *ServiceRepository) FindOneBy(field string, value string) (model.Service, dto.HttpErrorDto) {
	var service model.Service

	result := config.DB.Where(field+" = ?", value).First(&service)
	if result.RowsAffected == 0 {
		return model.Service{}, dto.HttpErrorDto{Message: "Service not found", Code: 404}
	}

	if result.Error != nil {
		return model.Service{}, dto.HttpErrorDto{Message: "Error while fetching service", Code: 500}
	}

	return service, dto.HttpErrorDto{}
}

func (wr *ServiceRepository) Delete(id uint64) error {
	result := config.DB.Delete(&model.Service{}, id)
	if result.Error != nil {
		return result.Error
	}
	if result.RowsAffected == 0 {
		return fmt.Errorf("no service found with ID: %d", id)
	}
	return nil
}

func (wr *ServiceRepository) Update(id uint64, updatedService model.Service) error {
	existingService, err := wr.FindOneBy("id", strconv.FormatUint(id, 10))
	if err.Code == 404 {
		return fmt.Errorf("service not found with ID: %d", id)
	} else if err.Code != 0 {
		return fmt.Errorf("error fetching service: %s", err.Message)
	}

	result := config.DB.Model(&existingService).Updates(updatedService)
	if result.Error != nil {
		return result.Error
	}

	return nil
}

func (wr *ServiceRepository) FindByUserID(userID uint64) ([]model.Service, dto.HttpErrorDto) {
    var services []model.Service
    result := config.DB.Where("user_id = ?", userID).Find(&services)

    if result.Error != nil {
        return nil, dto.HttpErrorDto{Message: "Error fetching services", Code: 500}
    }
    if result.RowsAffected == 0 {
        return nil, dto.HttpErrorDto{Message: "No services found for this user", Code: 404}
    }
    return services, dto.HttpErrorDto{}
}
