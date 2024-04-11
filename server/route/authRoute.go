package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func AuthRoutes(router *gin.Engine) {
	var authControllerPort controller_port.AuthControllerInterface = &controller.AuthController{}

	router.POST("/signup", authControllerPort.SignUp)
	router.POST("/signin", authControllerPort.SignIn)
	router.DELETE("/signout", authControllerPort.SignOut)

}
