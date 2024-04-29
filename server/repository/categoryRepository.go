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

type CategoryRepository struct {
    DB *gorm.DB
}

func (wr *CategoryRepository) FindAll() []model.Category {
    var categorys []model.Category

    result := config.DB.Find(&categorys)
    helper.ErrorPanic(result.Error)

    return categorys
}

func (wr *CategoryRepository) Create(category model.Category) (model.Category, dto.HttpErrorDto) {
    result := config.DB.Create(&category)
    if result.Error != nil {
        return model.Category{}, dto.HttpErrorDto{Message: "Error while creating category", Code: 500}
    }

    return category, dto.HttpErrorDto{}
}

func (wr *CategoryRepository) FindOneBy(field string, value string) (model.Category, dto.HttpErrorDto) {
    var category model.Category

    result := config.DB.Where(field+" = ?", value).First(&category)
    if result.RowsAffected == 0 {
        return model.Category{}, dto.HttpErrorDto{Message: "Category not found", Code: 404}
    }

    if result.Error != nil {
        return model.Category{}, dto.HttpErrorDto{Message: "Error while fetching category", Code: 500}
    }

    return category, dto.HttpErrorDto{}
}

func (wr *CategoryRepository) Delete(id uint64) error {
    result := config.DB.Delete(&model.Category{}, id)
    fmt.Println("CategoryService", result)

    if result.Error != nil {
        return result.Error
    }
    if result.RowsAffected == 0 {
        return fmt.Errorf("no category found with ID: %d", id)
    }
    return nil
}

func (wr *CategoryRepository) Update(id uint64, updatedCategory model.Category) error {
    existingCategory, err := wr.FindOneBy("id", strconv.FormatUint(id, 10))
    if err.Code == 404 {
        return fmt.Errorf("category not found with ID: %d", id)
    } else if err.Code != 0 {
        return fmt.Errorf("error fetching category: %s", err.Message)
    }

    result := config.DB.Model(&existingCategory).Updates(updatedCategory)
    if result.Error != nil {
        return result.Error
    }

    return nil
}
