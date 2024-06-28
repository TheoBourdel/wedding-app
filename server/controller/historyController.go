package controller

import (
	"net/http"
	"api/service"
	"strconv"
	"github.com/gin-gonic/gin"
)

type HistoryController struct {
	HistoryService service.HistoryService
}

func (hc *HistoryController) GetWeddingsByYear(ctx *gin.Context) {
	yearParam := ctx.DefaultQuery("year", "")
	year, err := strconv.Atoi(yearParam)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid year parameter"})
		return
	}

	weddings, err := hc.HistoryService.WeddingsByYear(year)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, weddings)
}
