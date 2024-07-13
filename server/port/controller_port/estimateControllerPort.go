package controller_port

import "github.com/gin-gonic/gin"

type EstimateControllerInterface interface {
	UpdateEstimate(ctx *gin.Context)
	DeleteEstimate(ctx *gin.Context)
	PayEstimate(ctx *gin.Context)
}
