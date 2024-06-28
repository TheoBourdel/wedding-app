package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func EstimateRoutes(router *gin.Engine) {
	var estimateControllerPort controller_port.EstimateControllerInterface = &controller.EstimateController{}

	router.PATCH("/user/:userId/estimate/:estimateId", estimateControllerPort.UpdateEstimate)
	router.DELETE("/user/:userId/estimate/:estimateId", estimateControllerPort.DeleteEstimate)

}
