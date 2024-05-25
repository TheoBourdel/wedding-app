package controller_port

import "github.com/gin-gonic/gin"

type ImageControllerInterface interface {
	GetImages(c *gin.Context)
	CreateImage(c *gin.Context)
	GetImageByID(c *gin.Context)
	DeleteImageByID(c *gin.Context)
	UpdateImage(c *gin.Context)
	UploadImage(c *gin.Context)
}
