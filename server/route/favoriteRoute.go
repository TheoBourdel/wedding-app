
package route

import (
    "api/controller"
    "api/port/controller_port"

    "github.com/gin-gonic/gin"
)

func FavoriteRoutes(router *gin.Engine) {
    var favoriteControllerPort controller_port.FavoriteControllerInterface = &controller.FavoriteController{}

    router.GET("/favorites", favoriteControllerPort.GetFavorites)
    router.POST("/addFavorite", favoriteControllerPort.CreateFavorite)
    router.GET("/favorite/:id", favoriteControllerPort.GetFavoriteByID)
    router.DELETE("/favorite/:id", favoriteControllerPort.DeleteFavoriteByID)
    router.PATCH("/favorite/:id", favoriteControllerPort.UpdateFavorite)
    router.GET("/user/:id/favorites", favoriteControllerPort.GetFavoritesByUserID)
    router.GET("/user/:id/favorites/services", favoriteControllerPort.GetFavoritesServicesByUserId)
}
