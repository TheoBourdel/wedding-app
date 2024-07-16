package controller

import (
	"api/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

type PaymentController struct {
	PaymentService service.PaymentService
}

func (pc *PaymentController) GetPaymentStatus(c *gin.Context) {
	status, err := pc.PaymentService.GetPaymentStatus()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, status)
}

func (pc *PaymentController) UpdatePaymentStatus(c *gin.Context) {
	var newStatus service.PaymentSettings
	if err := c.ShouldBindJSON(&newStatus); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := pc.PaymentService.UpdatePaymentStatus(newStatus); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, newStatus)
}
