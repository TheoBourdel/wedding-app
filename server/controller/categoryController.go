package controller

import (
	_ "api/docs"
	"net/http"
	"api/service"
	"api/model"
	"strconv"
	"github.com/gin-gonic/gin"
	"strings"
)

type CategoryController struct {
    CategoryService service.CategoryService

	
}

// GetCategorys godoc
// @Summary Get all categorys
// @Description Get a list of all categorys
// @Tags categorys
// @Accept json
// @Produce json
// @Success 200 {object} []model.Category
// @Router /categorys [get]
func (wc *CategoryController) GetCategorys(ctx *gin.Context) {
    categorys := wc.CategoryService.FindAll()

    ctx.Header("Content-Type", "application/json")
    ctx.JSON(http.StatusOK, categorys)
}

// CreateCategory godoc
// @Summary Create a new category
// @Description Create a new category
// @Tags categorys
// @Accept json
// @Produce json
// @Param category body model.Category true "Category object to be created"
// @Success 201 {object} model.Category
// @Failure 400 {string} string "Invalid request"

// @Router /categorys [post]
func (wc *CategoryController) CreateCategory(ctx *gin.Context) {
    var category model.Category
    if err := ctx.ShouldBindJSON(&category); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    createdCategory, err := wc.CategoryService.Create(category)
    if err.Code != 0 {
        ctx.JSON(err.Code, gin.H{"message": err.Message})
        return
    }

    ctx.JSON(http.StatusCreated, createdCategory)
}


// GetCategoryByID godoc
// @Summary Get a category by ID
// @Description Get a category by its ID
// @Tags categorys
// @Accept json
// @Produce json
// @Param id path int true "Category ID"
// @Success 200 {object} model.Category
// @Failure 404 {string} string "Category not found"
// @Router /categorys/{id} [get]
func (wc *CategoryController) GetCategoryByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid category ID"})
        return
    }

    category, err := wc.CategoryService.FindByID(id)
    if err != nil { // Check if there is an error
        // Handle the error appropriately, maybe log it
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        return
    }

    ctx.JSON(http.StatusOK, category)
}

// DeleteCategoryByID godoc
// @Summary Delete a category by ID
// @Description Delete a category by its ID
// @Tags categorys
// @Accept json
// @Produce json
// @Param id path int true "Category ID"
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid category ID"
// @Failure 404 {string} string "Category not found"
// @Failure 500 {string} string "Internal server error"
// @Router /categorys/{id} [delete]
func (wc *CategoryController) DeleteCategoryByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid category ID"})
        return
    }
	
	err = wc.CategoryService.Delete(id)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        return
    }

    ctx.Status(http.StatusNoContent)
}


// UpdateCategory godoc
// @Summary Update a category by ID
// @Description Update a category by its ID
// @Tags categorys
// @Accept json
// @Produce json
// @Param id path int true "Category ID"
// @Param category body model.Category true "Updated category object"
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid category ID or request body"
// @Failure 404 {string} string "Category not found"
// @Failure 500 {string} string "Internal server error"
// @Router /categorys/{id} [put]
func (wc *CategoryController) UpdateCategory(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid category ID"})
        return
    }

    // Bind the updated category data from the request body
    var updatedCategory model.Category
    if err := ctx.ShouldBindJSON(&updatedCategory); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
        return
    }

    // Call the Update method from CategoryService
    updateErr := wc.CategoryService.Update(id, updatedCategory)
    if updateErr != nil {
        if strings.Contains(updateErr.Error(), "category not found") {
            ctx.JSON(http.StatusNotFound, gin.H{"error": updateErr.Error()})
        } else {
            ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        }
        return
    }

    // If the update was successful, return No Content
    ctx.Status(http.StatusNoContent)
}
