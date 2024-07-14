
package repository_port

import (
    "api/dto"
    "api/model"
)

type FavoriteRepositoryInterface interface {
    FindAll() ([]model.Favorite, error)
    FindOneBy(field string, value string) (model.Favorite, dto.HttpErrorDto)
    Create(user model.Favorite) (model.Favorite, dto.HttpErrorDto)
    Delete(id uint64) error
    Update(id uint64, favorite model.Favorite) error
}
