package service

import (
	"api/dto"
	"api/model"
	"api/repository"
	"fmt"
	"strconv"
)

type UserService struct {
	UserRepository     repository.UserRepository
	EstimateRepository repository.EstimateRepository
	ServiceRepository  repository.ServiceRepository
}

func (us *UserService) FindAll(page int, pageSize int, query string) []model.User {
	users := us.UserRepository.FindAll(page, pageSize, query)
	return users
}

func (us *UserService) CreateEstimate(userId int, estimateDto dto.CreateEstimateDto) (model.Estimate, dto.HttpErrorDto) {
	user, error := us.UserRepository.FindOneBy("id", strconv.Itoa(userId))
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	var service model.Service
	service, error = us.ServiceRepository.FindOneBy("id", strconv.Itoa(int(estimateDto.ServiceID)))
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	provider, error := us.UserRepository.FindOneBy("id", strconv.Itoa(int(service.UserID)))
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	estimate := model.Estimate{
		Status:   "requesting",
		Content:  estimateDto.Content,
		Price:    0,
		Client:   user,
		Provider: provider,
		Service:  service,
	}

	estimate, error = us.EstimateRepository.CreateEstimate(estimate)
	if error != (dto.HttpErrorDto{}) {
		return model.Estimate{}, error
	}

	return estimate, dto.HttpErrorDto{}
}

func (us *UserService) GetUserEstimates(userId int) ([]model.Estimate, dto.HttpErrorDto) {

	// User
	user, error := us.UserRepository.FindOneBy("id", strconv.Itoa(userId))
	if error != (dto.HttpErrorDto{}) {
		return []model.Estimate{}, error
	}

	// Estimates
	var estimates []model.Estimate
	if user.Role == "marry" {
		estimates, error = us.EstimateRepository.FindAllBy("client_id", strconv.Itoa(userId))
	} else if user.Role == "provider" {
		estimates, error = us.EstimateRepository.FindAllBy("provider_id", strconv.Itoa(userId))
	}

	// Estimate's service
	for i, estimate := range estimates {
		// Load Service
		service, error := us.ServiceRepository.FindOneBy("id", strconv.Itoa(int(estimate.ServiceID)))
		if error != (dto.HttpErrorDto{}) {
			return []model.Estimate{}, error
		}
		estimates[i].Service = service

		// Load Client
		client, error := us.UserRepository.FindOneBy("id", strconv.Itoa(int(estimate.ClientID)))
		if error != (dto.HttpErrorDto{}) {
			return []model.Estimate{}, error
		}
		estimates[i].Client = client

		// Load Provider
		provider, error := us.UserRepository.FindOneBy("id", strconv.Itoa(int(estimate.ProviderID)))
		if error != (dto.HttpErrorDto{}) {
			return []model.Estimate{}, error
		}
		estimates[i].Provider = provider
	}

	return estimates, dto.HttpErrorDto{}
}

func (us *UserService) CreateUser(user model.User) (model.User, dto.HttpErrorDto) {
	user, error := us.UserRepository.Create(user)
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	return user, dto.HttpErrorDto{}
}

func (us *UserService) GetUser(id string) (model.User, dto.HttpErrorDto) {
	user, error := us.UserRepository.FindOneBy("id", id)
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	return user, dto.HttpErrorDto{}
}

func (us *UserService) DeleteUserByID(id int) error {
	err := us.UserRepository.DeleteByID(id)
	if err != nil {
		return fmt.Errorf("failed to delete user: %v", err)
	}
	return nil
}

func (us *UserService) UpdateUserFirebaseToken(userID uint, newToken string) (model.User, dto.HttpErrorDto) {
	user, err := us.UserRepository.UpdateFirebaseToken(userID, newToken)
	if err != (dto.HttpErrorDto{}) {
		return model.User{}, err
	}

	return user, dto.HttpErrorDto{}
}


func NewUserService(userRepo repository.UserRepository) *UserService {
	return &UserService{
		UserRepository: userRepo,
	}
}

func (us *UserService) UpdateUser(user model.User) (model.User, dto.HttpErrorDto) {
	user, error := us.UserRepository.Update(user)
	if error != (dto.HttpErrorDto{}) {
		return model.User{}, error
	}

	return user, dto.HttpErrorDto{}
}

