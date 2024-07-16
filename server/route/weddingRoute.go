package route

import (
	"api/controller"
	"api/port/controller_port"
	"api/middelware"


	"github.com/gin-gonic/gin"
)

func WeddingRoutes(router *gin.Engine) {
	var weddingControllerPort controller_port.WeddingControllerInterface = &controller.WeddingController{}

	router.GET("/weddings",middelware.RequireAuthAndAdmin, weddingControllerPort.GetWeddings)
	router.GET("/wedding/:id", middelware.RequireAuth, weddingControllerPort.GetWeddingByID)
	router.GET("/userwedding/:id", middelware.RequireAuth,weddingControllerPort.GetWeddingByUserID)
	// router.DELETE("/wedding/:id", weddingControllerPort.DeleteWeddingByID)
	router.PATCH("/wedding/:id", middelware.RequireAuth, weddingControllerPort.UpdateWedding)
	router.POST("/user/:id/wedding", middelware.RequireAuth, weddingControllerPort.CreateWedding)
	router.POST("/wedding/:id/organizer",middelware.RequireAuth, weddingControllerPort.AddWeddingOrganizer)
}
