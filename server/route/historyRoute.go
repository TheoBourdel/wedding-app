package route

import (
	"api/controller"
	"github.com/gin-gonic/gin"
)

func HistoryRoutes(router *gin.Engine) {
	var historyController = &controller.HistoryController{}
	router.GET("/weddingsByYear", historyController.GetWeddingsByYear) // Changez le chemin de la route pour éviter les conflits
}
