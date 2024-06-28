package route

import (
	"api/controller"
	"api/service"
	"github.com/gin-gonic/gin"
	"api/config"
)

func StatisticsRoutes(router *gin.Engine) {
	statisticsController := &controller.StatisticsController{
		StatisticsService: service.StatisticsService{DB: config.DB},
	}

	router.GET("/total_providers", statisticsController.GetTotalProviders)
	router.GET("/total_weddings", statisticsController.GetTotalWeddings)
	router.GET("/total_guests", statisticsController.GetTotalGuests)
	router.GET("/average_budget", statisticsController.GetAverageBudget)
	router.GET("/monthly_revenue", statisticsController.GetMonthlyRevenue)
}
