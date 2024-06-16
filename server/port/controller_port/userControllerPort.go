package controller_port

import "github.com/gin-gonic/gin"

type UserControllerInterface interface {
	GetUsers(c *gin.Context)
	CreateUser(c *gin.Context)
	GetUser(c *gin.Context)
	CreateUserEstimate(c *gin.Context)
	GetUserEstimates(c *gin.Context)
}
