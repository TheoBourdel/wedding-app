package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func ServiceRoutes(router *gin.Engine) {
	var serviceControllerPort controller_port.ServiceControllerInterface = &controller.ServiceController{}

	router.GET("/services", serviceControllerPort.GetServices)
	router.POST("/addservice", serviceControllerPort.CreateService)
	router.GET("/service/:id", serviceControllerPort.GetServiceByID)
	router.DELETE("/service/:id", serviceControllerPort.DeleteServiceByID)
	router.PATCH("/service/:id", serviceControllerPort.UpdateService)
	router.GET("/service/:id/images", serviceControllerPort.GetServiceImages)
	router.GET("/user/:userId/services", serviceControllerPort.GetServicesByUserID)




}
