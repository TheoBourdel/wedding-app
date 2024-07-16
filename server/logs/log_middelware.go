package logs

import (
	"api/controller"
	"api/model"
	"api/repository"
	"api/service"
	"log"
	"time"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func LoggerMiddleware(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		start := time.Now()

		clientIP := c.ClientIP()
		method := c.Request.Method
		path := c.Request.URL.Path

		log.Printf("Started %s %s from %s", method, path, clientIP)

		c.Next()

		statusCode := c.Writer.Status()
		duration := time.Since(start)

		log.Printf("Completed %s %s from %s in %v with status %d", method, path, clientIP, duration, statusCode)

		var errorMsg string
		if len(c.Errors) > 0 {
			errorMsg = c.Errors.String()
		}

		// Créer une entrée de log
		logEntry := model.Log{
			Timestamp:  time.Now(),
			Method:     method,
			Path:       path,
			ClientIP:   clientIP,
			StatusCode: statusCode,
			Duration:   duration,
			ErrorMsg:   errorMsg,
		}

		// Initialiser le repository, service et contrôleur localement dans le middleware
		logRepo := repository.NewLogRepository(db)
		logService := service.NewLogService(logRepo)
		logController := controller.NewLogController(logService)

		// Appeler le contrôleur pour enregistrer l'entrée de log
		c.Set("logEntry", logEntry)
		logController.CreateLog(c)
	}
}
