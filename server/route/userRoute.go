package route

import (
	"api/controller"
	"api/middelware"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func UserRoutes(router *gin.Engine) {
	var userControllerPort controller_port.UserControllerInterface = &controller.UserController{}

	//Auth & Admin
	// router.GET("/users", middelware.RequireAuthAndAdmin, userControllerPort.GetUsers)
	router.GET("/users",  userControllerPort.GetUsers)

	//Auth
	router.POST("/user", userControllerPort.CreateUser)
	router.GET("/user/:id", userControllerPort.GetUser)
	router.POST("/user/:id/estimate", userControllerPort.CreateUserEstimate)
	router.GET("/user/:id/estimates", userControllerPort.GetUserEstimates)
	router.PUT("/user/:id/token", userControllerPort.UpdateUserFirebaseToken)

}
