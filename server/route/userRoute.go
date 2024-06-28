package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func UserRoutes(router *gin.Engine) {
	var userControllerPort controller_port.UserControllerInterface = &controller.UserController{}

	router.GET("/users", userControllerPort.GetUsers)
	router.POST("/user", userControllerPort.CreateUser)
	router.GET("/user/:id", userControllerPort.GetUser)
	router.DELETE("/users/:id", userControllerPort.DeleteUser)
}
