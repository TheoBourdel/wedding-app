package controller_port

import "github.com/gin-gonic/gin"

type ServiceControllerInterface interface {
	GetServices(c *gin.Context)
	CreateService(c *gin.Context)
	GetServiceByID(c *gin.Context)
	DeleteServiceByID(c *gin.Context)
	UpdateService(c *gin.Context)
	GetServiceImages(c *gin.Context)
}
