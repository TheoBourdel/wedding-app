package controller

import (
	"api/model"
	"api/service"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type BudgetController struct {
	BudgetService service.BudgetService
}

// CreateBudget godoc
// @Summary Create a budget
// @Description Create a budget for a wedding
// @Tags budget
// @Accept json
// @Produce json
// @Param wedding_id path int true "Wedding ID"
// @Param budget body model.WeddingBudget true "budget info"
// @Security Bearer
// @Router /budgets [post]
func (bc *BudgetController) CreateBudget(ctx *gin.Context) {
	var request model.WeddingBudget
	if err := ctx.ShouldBindJSON(&request); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	log.Printf("Received request: %+v", request)

	request.CreatedAt = time.Now()
	request.UpdatedAt = time.Now()

	createdBudget, err := bc.BudgetService.Create(request)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	log.Printf("Created budget: %+v", createdBudget)

	ctx.JSON(http.StatusCreated, createdBudget)
}

// GetBudgetsByWeddingID godoc
// @Summary Get budgets by wedding ID
// @Description Get all budgets for a wedding
// @Tags budget
// @Accept json
// @Produce json
// @Param wedding_id path int true "Wedding ID"
// @Security Bearer
// @Router /weddings/{wedding_id}/budgets [get]
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

// UpdateBudget godoc
// @Summary Update a budget
// @Description Update a budget by ID
// @Tags budget
// @Accept json
// @Produce json
// @Param id path int true "Budget ID"
// @Security Bearer
// @Router /budgets/{id} [put]
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

// DeleteBudgetByID godoc
// @Summary Delete a budget
// @Description Delete a budget by ID
// @Tags budget
// @Accept json
// @Produce json
// @Param id path int true "Budget ID"
// @Security Bearer
// @Router /budgets/{id} [delete]
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

// GetTotalBudget godoc
// @Summary Get total budget
// @Description Get total budget for a wedding
// @Tags budget
// @Accept json
// @Produce json
// @Param wedding_id path int true "Wedding ID"
// @Security Bearer
// @Router /weddings/{wedding_id}/total_budget [get]
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
