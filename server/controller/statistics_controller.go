package controller

import (
	"net/http"
	"api/service"
	"github.com/gin-gonic/gin"
	"strconv"
	"time"
)

type StatisticsController struct {
	StatisticsService service.StatisticsService
}

func (sc *StatisticsController) GetTotalProviders(ctx *gin.Context) {
	total, err := sc.StatisticsService.TotalProviders()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, total)
}

func (sc *StatisticsController) GetTotalWeddings(ctx *gin.Context) {
	total, err := sc.StatisticsService.TotalWeddings()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, total)
}

func (sc *StatisticsController) GetTotalGuests(ctx *gin.Context) {
	total, err := sc.StatisticsService.TotalGuests()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, total)
}

func (sc *StatisticsController) GetAverageBudget(ctx *gin.Context) {
	average, err := sc.StatisticsService.AverageBudget()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, average)
}

func (sc *StatisticsController) GetMonthlyRevenue(ctx *gin.Context) {
	    yearParam := ctx.DefaultQuery("year", strconv.Itoa(time.Now().Year()))
    	year, err := strconv.Atoi(yearParam)
    	if err != nil {
    		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid year parameter"})
    		return
    	}

    	revenues, err := sc.StatisticsService.MonthlyRevenue(year)
    	if err != nil {
    		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
    		return
    	}
    	ctx.JSON(http.StatusOK, revenues)
}