package route

import (
	"api/controller"
	"api/port/controller_port"
	"api/service"
	"api/config"

	"github.com/gin-gonic/gin"
)

func BudgetRoutes(router *gin.Engine) {
	var budgetService = service.NewBudgetService(config.DB)
	var budgetControllerPort controller_port.BudgetControllerInterface = &controller.BudgetController{BudgetService: budgetService}

	router.POST("/budgets", budgetControllerPort.CreateBudget)
	router.GET("/weddings/:wedding_id/budgets", budgetControllerPort.GetBudgetsByWeddingID)
	router.PUT("/budgets/:id", budgetControllerPort.UpdateBudget)
	router.DELETE("/budgets/:id", budgetControllerPort.DeleteBudgetByID)
	router.GET("/weddings/:wedding_id/total_budget", budgetControllerPort.GetTotalBudget)

}
