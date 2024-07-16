package route

import (
	"api/controller"
	"api/service"
	"api/config"
	"github.com/gin-gonic/gin"
	"api/middelware"

)

func HistoryRoutes(router *gin.Engine) {
	historyService := service.HistoryService{DB: config.DB}
	historyController := &controller.HistoryController{
		HistoryService: historyService,
	}

	router.GET("/weddingsByYear",middelware.RequireAuth, historyController.GetWeddingsByYear)
}
