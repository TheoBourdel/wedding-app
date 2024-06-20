package controller_port

import "github.com/gin-gonic/gin"

type OrganizerControllerInterface interface {
	GetOrganizers(c *gin.Context)
	DeleteOrganizer(c *gin.Context)
}
