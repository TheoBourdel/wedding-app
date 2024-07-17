package route

import (
	"api/config"
	"api/controller"
	"api/middelware"
	"api/port/controller_port"
	"api/service"

	"github.com/gin-gonic/gin"
)

func BudgetRoutes(router *gin.Engine) {
	var budgetService = service.NewBudgetService(config.DB)
	var budgetControllerPort controller_port.BudgetControllerInterface = &controller.BudgetController{BudgetService: budgetService}

	router.POST("/budgets", middelware.RequireAuth, budgetControllerPort.CreateBudget)
	router.GET("/weddings/:wedding_id/budgets", middelware.RequireAuth, budgetControllerPort.GetBudgetsByWeddingID)
	router.PUT("/budgets/:id", middelware.RequireAuth, budgetControllerPort.UpdateBudget)
	router.DELETE("/budgets/:id", middelware.RequireAuth, budgetControllerPort.DeleteBudgetByID)
	router.GET("/weddings/:wedding_id/total_budget", middelware.RequireAuth, budgetControllerPort.GetTotalBudget)

}
