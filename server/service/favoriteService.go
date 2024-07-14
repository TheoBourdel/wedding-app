
package service

import (
    "api/model"
    "api/repository"
    "api/dto" 
    "strconv"
    "fmt"
)

type FavoriteService struct {
    FavoriteRepository repository.FavoriteRepository
}

func (svc *FavoriteService) FindAll() []model.Favorite {
    favorites := svc.FavoriteRepository.FindAll()

    return favorites
}

func (svc *FavoriteService) Create(favorite model.Favorite) (model.Favorite, dto.HttpErrorDto) {
    createdFavorite, err := svc.FavoriteRepository.Create(favorite)
    if err.Code != 0 {
        return model.Favorite{}, err
    }

    return createdFavorite, dto.HttpErrorDto{}
}

func (svc *FavoriteService) FindByID(id uint64) (model.Favorite, error) {
    favorite, err := svc.FavoriteRepository.FindOneBy("id", strconv.FormatUint(id, 10))
    if err.Code != 0 {
        return model.Favorite{}, fmt.Errorf("favorite not found: %s", err.Message)
    }

    return favorite, nil
}

func (svc *FavoriteService) Delete(id uint64) error {
    _, findErr := svc.FavoriteRepository.FindOneBy("id", strconv.FormatUint(id, 10))

    if findErr.Code == 404 {
        return fmt.Errorf("favorite not found with ID: %d", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf("error fetching favorite: %s", findErr.Message)
    }

    deleteErr := svc.FavoriteRepository.Delete(id)
    fmt.Println("FavoriteService", deleteErr)

    if deleteErr != nil {
        return fmt.Errorf("error deleting favorite: %s", deleteErr.Error())
    }
    return nil
}

func (svc *FavoriteService) Update(id uint64, updatedFavorite model.Favorite) error {
    _, findErr := svc.FavoriteRepository.FindOneBy("id", strconv.FormatUint(id, 10))
    if findErr.Code == 404 {
        return fmt.Errorf("favorite not found with ID: %d", id)
    } else if findErr.Code != 0 {
        return fmt.Errorf("error fetching favorite: %s", findErr.Message)
    }

    updateErr := svc.FavoriteRepository.Update(id, updatedFavorite)
    if updateErr != nil {
        return fmt.Errorf("error updating favorite: %s", updateErr.Error())
    }

    return nil
}
