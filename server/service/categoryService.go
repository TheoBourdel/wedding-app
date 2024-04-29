package service

import (
	"api/model"
	"api/repository"
    "api/dto" 
    "strconv"
    "fmt"

)

type CategoryService struct {
    CategoryRepository repository.CategoryRepository
	UserRepository repository.UserRepository

}

func (ws *CategoryService) FindAll() []model.Category {
    categorys := ws.CategoryRepository.FindAll()

    return categorys
}

func (ws *CategoryService) Create(category model.Category) (model.Category, dto.HttpErrorDto) {

    createdCategory, err := ws.CategoryRepository.Create(category)
    if err.Code != 0 {
        return model.Category{}, err
    }

    return createdCategory, dto.HttpErrorDto{}
}

func (ws *CategoryService) FindByID(id uint64) (model.Category, error) {
    category, err := ws.CategoryRepository.FindOneBy("id", strconv.FormatUint(id, 10))
    if err.Code != 0 {
        return model.Category{}, fmt.Errorf("category not found: %s", err.Message)
    }

    return category, nil
}

func (ws *CategoryService) Delete(id uint64) error {

    _, findErr := ws.CategoryRepository.FindOneBy("id", strconv.FormatUint(id, 10))

    if findErr.Code == 404 {
        return fmt.Errorf("category not found with ID: %d", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf("error fetching category: %s", findErr.Message)
    }

    deleteErr := ws.CategoryRepository.Delete(id)
    fmt.Println("CategoryService", deleteErr)

    if deleteErr != nil {
        return fmt.Errorf("error deleting category: %s", deleteErr.Error())
    }
    return nil
}

func (ws *CategoryService) Update(id uint64, updatedCategory model.Category) error {
    _, findErr := ws.CategoryRepository.FindOneBy("id", strconv.FormatUint(id, 10))
    if findErr.Code == 404 {
        return fmt.Errorf("category not found with ID: %d", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf("error fetching category: %s", findErr.Message)
    }

    updateErr := ws.CategoryRepository.Update(id, updatedCategory)
    if updateErr != nil {
        return fmt.Errorf("error updating category: %s", updateErr.Error())
    }

    return nil
}
