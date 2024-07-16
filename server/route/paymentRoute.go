package route

import (
	"api/controller"
	"api/service"
	"api/config"
	"github.com/gin-gonic/gin"
)


func PaymentRoutes(router *gin.Engine) {
	paymentController := &controller.PaymentController{
		PaymentService: service.PaymentService{DB: config.DB},
	}

	router.GET("/api/payment-status", paymentController.GetPaymentStatus)
	router.POST("/api/payment-status/update", paymentController.UpdatePaymentStatus)
}
