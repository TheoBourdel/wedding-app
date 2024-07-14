// favoriteName: favorite
package controller

import (
    _ "api/docs"
    "net/http"
    "api/service"
    "api/model"
    "strconv"
    "github.com/gin-gonic/gin"
)

type FavoriteController struct {
    FavoriteService service.FavoriteService
}

func (ctrl *FavoriteController) GetFavorites(ctx *gin.Context) {
    favorites := ctrl.FavoriteService.FindAll()
    ctx.Header("Content-Type", "application/json")
    ctx.JSON(http.StatusOK, favorites)
}

func (ctrl *FavoriteController) CreateFavorite(ctx *gin.Context) {
    var favorite model.Favorite
    if err := ctx.ShouldBindJSON(&favorite); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    createdFavorite, err := ctrl.FavoriteService.Create(favorite)
    if err.Code != 0 {
        ctx.JSON(err.Code, gin.H{"message": err.Message})
        return
    }
    ctx.JSON(http.StatusCreated, createdFavorite)
}

func (ctrl *FavoriteController) GetFavoriteByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid favorite ID"})
        return
    }
    favorite, err := ctrl.FavoriteService.FindByID(id)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        return
    }
    ctx.JSON(http.StatusOK, favorite)
}

func (ctrl *FavoriteController) DeleteFavoriteByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid favorite ID"})
        return
    }
    err = ctrl.FavoriteService.Delete(id)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        return
    }
    ctx.Status(http.StatusNoContent)
}

func (ctrl *FavoriteController) UpdateFavorite(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid favorite ID"})
        return
    }
    var updatedFavorite model.Favorite
    if err := ctx.ShouldBindJSON(&updatedFavorite); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
        return
    }
    err = ctrl.FavoriteService.Update(id, updatedFavorite)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        return
    }
    ctx.Status(http.StatusNoContent)
}
