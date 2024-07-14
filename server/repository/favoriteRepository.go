
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

type FavoriteRepository struct {
    DB *gorm.DB
}

func (repo *FavoriteRepository) FindAll() []model.Favorite {
    var favorites []model.Favorite

    result := config.DB.Find(&favorites)
    helper.ErrorPanic(result.Error)

    return favorites
}

func (repo *FavoriteRepository) Create(favorite model.Favorite) (model.Favorite, dto.HttpErrorDto) {
    result := config.DB.Create(&favorite)
    if result.Error != nil {
        return model.Favorite{}, dto.HttpErrorDto{Message: "Error while creating favorite", Code: 500}
    }

    return favorite, dto.HttpErrorDto{}
}

func (repo *FavoriteRepository) FindOneBy(field string, value string) (model.Favorite, dto.HttpErrorDto) {
    var favorite model.Favorite

    result := config.DB.Where(field+" = ?", value).First(&favorite)
    if result.RowsAffected == 0 {
        return model.Favorite{}, dto.HttpErrorDto{Message: "Favorite not found", Code: 404}
    }

    if result.Error != nil {
        return model.Favorite{}, dto.HttpErrorDto{Message: "Error while fetching favorite", Code: 500}
    }

    return favorite, dto.HttpErrorDto{}
}

func (repo *FavoriteRepository) Delete(id uint64) error {
    result := config.DB.Delete(&model.Favorite{}, id)
    fmt.Println("FavoriteService", result)

    if result.Error != nil {
        return result.Error
    }
    if result.RowsAffected == 0 {
        return fmt.Errorf("no favorite found with ID: %d", id)
    }
    return nil
}

func (repo *FavoriteRepository) Update(id uint64, updatedFavorite model.Favorite) error {
    existingFavorite, err := repo.FindOneBy("id", strconv.FormatUint(id, 10))
    if err.Code == 404 {
        return fmt.Errorf("favorite not found with ID: %d", id)
    } else if err.Code != 0 {
        return fmt.Errorf("error fetching favorite: %s", err.Message)
    }

    result := config.DB.Model(&existingFavorite).Updates(updatedFavorite)
    if result.Error != nil {
        return result.Error
    }

    return nil
}
