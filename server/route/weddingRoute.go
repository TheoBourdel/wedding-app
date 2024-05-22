package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func WeddingRoutes(router *gin.Engine) {
	var weddingControllerPort controller_port.WeddingControllerInterface = &controller.WeddingController{}

	router.GET("/weddings", weddingControllerPort.GetWeddings)
	router.GET("/wedding/:id", weddingControllerPort.GetWeddingByID)
	router.GET("/userwedding/:id", weddingControllerPort.GetWeddingByUserID)
	router.DELETE("/wedding/:id", weddingControllerPort.DeleteWeddingByID)
	router.PATCH("/wedding/:id", weddingControllerPort.UpdateWedding)
	router.POST("/user/:id/wedding", weddingControllerPort.CreateWedding)
	router.POST("/wedding/:id/organizer", weddingControllerPort.AddWeddingOrganizer)
}
