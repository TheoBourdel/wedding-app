package route

import (
	"api/controller"
	"api/port/controller_port"
	"api/middelware"

	"github.com/gin-gonic/gin"
)

func EstimateRoutes(router *gin.Engine) {
	var estimateControllerPort controller_port.EstimateControllerInterface = &controller.EstimateController{}

	router.PATCH("/user/:userId/estimate/:estimateId", middelware.RequireAuth, estimateControllerPort.UpdateEstimate)
	router.DELETE("/user/:userId/estimate/:estimateId" ,middelware.RequireAuth, estimateControllerPort.DeleteEstimate)
	router.POST("/pay", estimateControllerPort.PayEstimate)

}
