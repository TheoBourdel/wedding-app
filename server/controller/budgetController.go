package controller

import (
	"api/model"
	"api/service"
	"net/http"
	"github.com/gin-gonic/gin"
	"strconv"
)

type BudgetController struct {
	BudgetService service.BudgetService
}

type CategoryBudget struct {
	CategoryID uint    `json:"category_id"`
	Amount     float64 `json:"amount"`
}

type CreateBudgetRequest struct {
	WeddingID       uint             `json:"wedding_id"`
	CategoryBudgets []CategoryBudget `json:"category_budgets"`
}

func (bc *BudgetController) CreateBudget(ctx *gin.Context) {
	var request CreateBudgetRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	for _, cb := range request.CategoryBudgets {
		budget := model.WeddingBudget{
			WeddingID:  request.WeddingID,
			CategoryID: cb.CategoryID,
			Amount:     cb.Amount,
		}

		_, err := bc.BudgetService.Create(budget)
		if err != nil {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
	}

	ctx.JSON(http.StatusCreated, gin.H{"message": "Budgets created successfully"})
}

func (bc *BudgetController) GetBudgetsByWeddingID(ctx *gin.Context) {
	weddingID, err := strconv.ParseUint(ctx.Param("wedding_id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid wedding ID"})
		return
	}

	budgets, err := bc.BudgetService.FindByWeddingID(uint(weddingID))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, budgets)
}

func (bc *BudgetController) UpdateBudget(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid budget ID"})
		return
	}

	var updatedBudget model.WeddingBudget
	if err := ctx.ShouldBindJSON(&updatedBudget); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	updateErr := bc.BudgetService.Update(uint(id), updatedBudget)
	if updateErr != nil {
		if updateErr.Error() == "budget not found" {
			ctx.JSON(http.StatusNotFound, gin.H{"error": updateErr.Error()})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		}
		return
	}

	ctx.Status(http.StatusNoContent)
}

func (bc *BudgetController) DeleteBudgetByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid budget ID"})
		return
	}

	deleteErr := bc.BudgetService.Delete(uint(id))
	if deleteErr != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	ctx.Status(http.StatusNoContent)
}


func (bc *BudgetController) GetTotalBudget(ctx *gin.Context) {
    weddingID, err := strconv.ParseUint(ctx.Param("wedding_id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid wedding ID"})
        return
    }

    budget, err := bc.BudgetService.GetTotalBudget(uint(weddingID))
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    ctx.JSON(http.StatusOK, gin.H{"total_budget": budget})
}

