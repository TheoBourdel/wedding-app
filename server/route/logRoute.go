package route

import (
	"api/config"
	"api/controller"
	"api/repository"
	"api/service"
	"github.com/gin-gonic/gin"
	"api/middelware"
)

func LogRoutes(router *gin.Engine) {
	logRepo := repository.NewLogRepository(config.DB)
	logService := service.NewLogService(logRepo)
	logController := controller.NewLogController(logService)

	router.GET("/logs", middelware.RequireAuth, logController.GetAllLogs)
	router.POST("/logs", middelware.RequireAuth,logController.CreateLog)
}
