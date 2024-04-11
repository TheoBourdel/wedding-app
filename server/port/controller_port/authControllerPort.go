package controller_port

import "github.com/gin-gonic/gin"

type AuthControllerInterface interface {
	SignUp(c *gin.Context)
	SignIn(c *gin.Context)
	SignOut(c *gin.Context)
}
