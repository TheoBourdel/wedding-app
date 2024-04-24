package repository

import (
	"api/dto"
	"api/helper"
	"api/model"
	"api/config"
	"gorm.io/gorm"
	"strconv"
    "fmt"
)

type ServiceRepository struct {
    DB *gorm.DB
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
    fmt.Println("ServiceService", result)

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
