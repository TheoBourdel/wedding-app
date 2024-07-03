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
	router.GET("/users", middelware.RequireAuthAndAdmin, userControllerPort.GetUsers)

	//Auth
	router.POST("/user", middelware.RequireAuth, userControllerPort.CreateUser)
	router.GET("/user/:id", middelware.RequireAuth, userControllerPort.GetUser)
	router.POST("/user/:id/estimate", middelware.RequireAuth, userControllerPort.CreateUserEstimate)
	router.GET("/user/:id/estimates", middelware.RequireAuth, userControllerPort.GetUserEstimates)
	router.PUT("/user/:id/token", middelware.RequireAuth, userControllerPort.UpdateUserFirebaseToken)

}
