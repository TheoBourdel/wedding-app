
package route

import (
    "api/controller"
    "api/port/controller_port"
	"api/middelware"

    "github.com/gin-gonic/gin"
)

func FavoriteRoutes(router *gin.Engine) {
    var favoriteControllerPort controller_port.FavoriteControllerInterface = &controller.FavoriteController{}

    router.GET("/favorites",middelware.RequireAuth,  favoriteControllerPort.GetFavorites)
    router.POST("/addFavorite",middelware.RequireAuth,  favoriteControllerPort.CreateFavorite)
    router.GET("/favorite/:id",middelware.RequireAuth,  favoriteControllerPort.GetFavoriteByID)
    router.DELETE("/favorite/:id",middelware.RequireAuth,  favoriteControllerPort.DeleteFavoriteByID)
    router.PATCH("/favorite/:id",middelware.RequireAuth,  favoriteControllerPort.UpdateFavorite)
    router.GET("/user/:id/favorites",middelware.RequireAuth,  favoriteControllerPort.GetFavoritesByUserID)
    router.GET("/user/:id/favorites/services",middelware.RequireAuth,  favoriteControllerPort.GetFavoritesServicesByUserId)
}
