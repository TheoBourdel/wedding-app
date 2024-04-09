package controller_port

import "github.com/gin-gonic/gin"

type UserControllerInterface interface {
	GetUsers(c *gin.Context)
	// SaveUser(c *gin.Context)
	// UpdateUser(c *gin.Context)
	// DeleteUser(c *gin.Context)
	// GetUser(c *gin.Context)
}
