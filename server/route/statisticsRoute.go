package route

import (
	"api/controller"
	"api/service"
	"github.com/gin-gonic/gin"
	"api/config"
	"api/middelware"

)

func StatisticsRoutes(router *gin.Engine) {
	statisticsController := &controller.StatisticsController{
		StatisticsService: service.StatisticsService{DB: config.DB},
	}

	router.GET("/total_providers", middelware.RequireAuthAndAdmin, statisticsController.GetTotalProviders)
	router.GET("/total_weddings", middelware.RequireAuthAndAdmin, statisticsController.GetTotalWeddings)
	router.GET("/total_guests",middelware.RequireAuthAndAdmin,  statisticsController.GetTotalGuests)
	router.GET("/average_budget",middelware.RequireAuthAndAdmin,  statisticsController.GetAverageBudget)
	router.GET("/monthly_revenue", middelware.RequireAuthAndAdmin, statisticsController.GetMonthlyRevenue)
}
