package controller_port

import "github.com/gin-gonic/gin"

type CategoryControllerInterface interface {
	GetCategorys(c *gin.Context)
	CreateCategory(c *gin.Context)
	GetCategoryByID(c *gin.Context)
	DeleteCategoryByID(c *gin.Context)
	UpdateCategory(c *gin.Context)
}
