package service

import (
	"api/model"
	"api/repository"
    "api/dto" 
    "strconv"
    "fmt"

)

type ImageService struct {
    ImageRepository repository.ImageRepository
	UserRepository repository.UserRepository

}

func (ws *ImageService) FindAll() []model.Image {
    images := ws.ImageRepository.FindAll()

    return images
}

func (ws *ImageService) Create(image model.Image) (model.Image, dto.HttpErrorDto) {

    createdImage, err := ws.ImageRepository.Create(image)
    if err.Code != 0 {
        return model.Image{}, err
    }

    return createdImage, dto.HttpErrorDto{}
}

func (ws *ImageService) FindByID(id uint64) (model.Image, error) {
    image, err := ws.ImageRepository.FindOneBy("id", strconv.FormatUint(id, 10))
    if err.Code != 0 {
        return model.Image{}, fmt.Errorf("image not found: %s", err.Message)
    }

    return image, nil
}

func (ws *ImageService) Delete(id uint64) error {

    _, findErr := ws.ImageRepository.FindOneBy("id", strconv.FormatUint(id, 10))

    if findErr.Code == 404 {
        return fmt.Errorf("image not found with ID: %d", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf("error fetching image: %s", findErr.Message)
    }

    deleteErr := ws.ImageRepository.Delete(id)
    fmt.Println("ImageService", deleteErr)

    if deleteErr != nil {
        return fmt.Errorf("error deleting image: %s", deleteErr.Error())
    }
    return nil
}

func (ws *ImageService) Update(id uint64, updatedImage model.Image) error {
    _, findErr := ws.ImageRepository.FindOneBy("id", strconv.FormatUint(id, 10))
    if findErr.Code == 404 {
        return fmt.Errorf("image not found with ID: %d", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf("error fetching image: %s", findErr.Message)
    }

    updateErr := ws.ImageRepository.Update(id, updatedImage)
    if updateErr != nil {
        return fmt.Errorf("error updating image: %s", updateErr.Error())
    }

    return nil
}

