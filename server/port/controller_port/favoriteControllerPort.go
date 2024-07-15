
package controller_port

import "github.com/gin-gonic/gin"

type FavoriteControllerInterface interface {
    GetFavorites(c *gin.Context)
    CreateFavorite(c *gin.Context)
    GetFavoriteByID(c *gin.Context)
    DeleteFavoriteByID(c *gin.Context)
    UpdateFavorite(c *gin.Context)
    GetFavoritesByUserID(c *gin.Context)
    GetFavoritesServicesByUserId(c *gin.Context)
}
