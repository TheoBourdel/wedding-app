package controller

import (
	"api/model"
	"api/service"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
)

type LogController struct {
	LogService *service.LogService
}

func NewLogController(logService *service.LogService) *LogController {
	return &LogController{LogService: logService}
}

func (lc *LogController) CreateLog(ctx *gin.Context) {
	logEntry, exists := ctx.Get("logEntry")
	if !exists {
		log.Println("Log entry not found in context")
		return
	}

	logModel, ok := logEntry.(model.Log)
	if !ok {
		log.Println("Invalid log entry format")
		return
	}

	_, err := lc.LogService.Create(logModel)
	if err != nil {
		log.Printf("Failed to create log: %v", err)
	}
}

func (lc *LogController) GetAllLogs(ctx *gin.Context) {
	logs, err := lc.LogService.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, logs)
}
