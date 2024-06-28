package route

import (
	"api/controller"
	"api/service"
	"api/config"
	"github.com/gin-gonic/gin"
)

func HistoryRoutes(router *gin.Engine) {
	historyService := service.HistoryService{DB: config.DB}
	historyController := &controller.HistoryController{
		HistoryService: historyService,
	}

	router.GET("/weddingsByYear", historyController.GetWeddingsByYear)
}
