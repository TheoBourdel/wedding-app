package controller_port

import (
	"github.com/gin-gonic/gin"
)

type BudgetControllerInterface interface {
	CreateBudget(ctx *gin.Context)
	GetBudgetsByWeddingID(ctx *gin.Context)
	UpdateBudget(ctx *gin.Context)
	DeleteBudgetByID(ctx *gin.Context)
	GetTotalBudget(ctx *gin.Context)
}
