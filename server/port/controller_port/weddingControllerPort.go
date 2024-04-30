package controller_port

import "github.com/gin-gonic/gin"

type WeddingControllerInterface interface {
	AddWeddingOrganizer(c *gin.Context)
	GetWeddings(c *gin.Context)
	CreateWedding(c *gin.Context)
	GetWeddingByID(c *gin.Context)
	DeleteWeddingByID(c *gin.Context)
	UpdateWedding(c *gin.Context)
	GetWeddingByUserID(c *gin.Context)
}
