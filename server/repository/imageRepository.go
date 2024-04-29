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

type ImageRepository struct {
    DB *gorm.DB
}

func (wr *ImageRepository) FindAll() []model.Image {
    var images []model.Image

    result := config.DB.Find(&images)
    helper.ErrorPanic(result.Error)

    return images
}

func (wr *ImageRepository) Create(image model.Image) (model.Image, dto.HttpErrorDto) {
    result := config.DB.Create(&image)
    if result.Error != nil {
        return model.Image{}, dto.HttpErrorDto{Message: "Error while creating image", Code: 500}
    }

    return image, dto.HttpErrorDto{}
}

func (wr *ImageRepository) FindOneBy(field string, value string) (model.Image, dto.HttpErrorDto) {
    var image model.Image

    result := config.DB.Where(field+" = ?", value).First(&image)
    if result.RowsAffected == 0 {
        return model.Image{}, dto.HttpErrorDto{Message: "Image not found", Code: 404}
    }

    if result.Error != nil {
        return model.Image{}, dto.HttpErrorDto{Message: "Error while fetching image", Code: 500}
    }

    return image, dto.HttpErrorDto{}
}

func (wr *ImageRepository) Delete(id uint64) error {
    result := config.DB.Delete(&model.Image{}, id)
    fmt.Println("ImageService", result)

    if result.Error != nil {
        return result.Error
    }
    if result.RowsAffected == 0 {
        return fmt.Errorf("no image found with ID: %d", id)
    }
    return nil
}

func (wr *ImageRepository) Update(id uint64, updatedImage model.Image) error {
    existingImage, err := wr.FindOneBy("id", strconv.FormatUint(id, 10))
    if err.Code == 404 {
        return fmt.Errorf("image not found with ID: %d", id)
    } else if err.Code != 0 {
        return fmt.Errorf("error fetching image: %s", err.Message)
    }

    result := config.DB.Model(&existingImage).Updates(updatedImage)
    if result.Error != nil {
        return result.Error
    }

    return nil
}
