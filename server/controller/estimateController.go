package controller

import (
	_ "api/docs"
	"api/model"

	"api/dto"
	"api/service"

	"strconv"

	"github.com/gin-gonic/gin"
)

type EstimateController struct {
	EstimateService service.EstimateService
}

func (ec *EstimateController) UpdateEstimate(ctx *gin.Context) {
	userId, _ := strconv.Atoi(ctx.Param("userId"))

	estimateId, _ := strconv.Atoi(ctx.Param("estimateId"))

	var body model.Estimate
	if err := ctx.Bind(&body); err != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request body"})
		return
	}

	estimate, error := ec.EstimateService.UpdateEstimate(userId, estimateId, body)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.JSON(200, estimate)
}

func (ec *EstimateController) DeleteEstimate(ctx *gin.Context) {
	userId, _ := strconv.Atoi(ctx.Param("userId"))

	estimateId, _ := strconv.Atoi(ctx.Param("estimateId"))

	error := ec.EstimateService.DeleteEstimate(userId, estimateId)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.JSON(204, nil)
}
