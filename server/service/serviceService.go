package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"fmt"
	"strconv"
)

type ServiceService struct {
	ServiceRepository repository.ServiceRepository
	UserRepository    repository.UserRepository
}

func (ws *ServiceService) FindAll() []model.Service {
	services := ws.ServiceRepository.FindAll()

	return services
}

func (ws *ServiceService) Create(service model.Service) (model.Service, dto.HttpErrorDto) {

	_, err := ws.UserRepository.FindOneBy("id", strconv.Itoa(int(service.UserID)))

	if err.Code != 0 {
		return model.Service{}, err
	}

	createdService, err := ws.ServiceRepository.Create(service)
	if err.Code != 0 {
		return model.Service{}, err
	}

	return createdService, dto.HttpErrorDto{}
}

func (ws *ServiceService) FindByID(id uint64) (model.Service, error) {
	service, err := ws.ServiceRepository.FindOneBy("id", strconv.FormatUint(id, 10))
	if err.Code != 0 {
		return model.Service{}, fmt.Errorf("service not found: %s", err.Message)
	}

	return service, nil
}

func (ws *ServiceService) Delete(id uint64) error {

	_, findErr := ws.ServiceRepository.FindOneBy("id", strconv.FormatUint(id, 10))

	if findErr.Code == 404 {
		return fmt.Errorf("service not found with ID: %d", id)
	} else if findErr.Code != 0 {
		return fmt.Errorf("error fetching service: %s", findErr.Message)
	}

	deleteErr := ws.ServiceRepository.Delete(id)
	fmt.Println("ServiceService", deleteErr)

	if deleteErr != nil {
		return fmt.Errorf("error deleting service: %s", deleteErr.Error())
	}
	return nil
}

func (ws *ServiceService) Update(id uint64, updatedService model.Service) error {
	_, findErr := ws.ServiceRepository.FindOneBy("id", strconv.FormatUint(id, 10))
	if findErr.Code == 404 {
		return fmt.Errorf("service not found with ID: %d", id)
	} else if findErr.Code != 0 {
		return fmt.Errorf("error fetching service: %s", findErr.Message)
	}

	updateErr := ws.ServiceRepository.Update(id, updatedService)
	if updateErr != nil {
		return fmt.Errorf("error updating service: %s", updateErr.Error())
	}

	return nil
}

func (ws *ServiceService) FindByUserID(userID uint64) ([]model.Service, error) {
	services, err := ws.ServiceRepository.FindByUserID(userID)
	if err.Code != 0 {
		return nil, fmt.Errorf("error fetching services: %s", err.Message)
	}
	return services, nil
}

func (ws *ServiceService) SearchByName(name string) ([]model.Service, error) {
	services, err := ws.ServiceRepository.SearchByName(name)
	if err.Code != 0 {
		return nil, fmt.Errorf("error fetching services: %s", err.Message)
	}
	return services, nil
}
