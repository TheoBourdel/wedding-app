package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func WeddingRoutes(router *gin.Engine) {
	var weddingControllerPort controller_port.WeddingControllerInterface = &controller.WeddingController{}

	router.GET("/weddings", weddingControllerPort.GetWeddings)
	router.POST("/wedding", weddingControllerPort.CreateWedding)
	router.GET("/wedding/:id", weddingControllerPort.GetWeddingByID)
	router.GET("/userwedding/:id", weddingControllerPort.GetWeddingByUserID)
	router.DELETE("/wedding/:id", weddingControllerPort.DeleteWeddingByID)
	router.PATCH("/wedding/:id", weddingControllerPort.UpdateWedding)

}
