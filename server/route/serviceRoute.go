package route

import (
	"api/controller"
	"api/port/controller_port"
	"api/middelware"

	"github.com/gin-gonic/gin"
)

func ServiceRoutes(router *gin.Engine) {
	var serviceControllerPort controller_port.ServiceControllerInterface = &controller.ServiceController{}

	router.GET("/services", middelware.RequireAuth, serviceControllerPort.GetServices)
	router.POST("/addservice", middelware.RequireAuth, serviceControllerPort.CreateService)
	router.GET("/service/:id",middelware.RequireAuth, serviceControllerPort.GetServiceByID)
	router.DELETE("/service/:id", middelware.RequireAuth, serviceControllerPort.DeleteServiceByID)
	router.PATCH("/service/:id", middelware.RequireAuth, serviceControllerPort.UpdateService)
	router.GET("/service/:id/images",middelware.RequireAuth,  serviceControllerPort.GetServiceImages)
	router.GET("/user/:id/services", middelware.RequireAuth, serviceControllerPort.GetServicesByUserID)
	router.GET("/services/search", middelware.RequireAuth, serviceControllerPort.SearchServicesByName)

	router.Static("/uploads", "/server/uploads")

}
