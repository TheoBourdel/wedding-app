package controller

import (
	_ "api/docs"
	"api/dto"
	"api/model"
	"api/service"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)

type WeddingController struct {
	WeddingService service.WeddingService
	UserService    service.UserService
}

type HttpErrorDto struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
}

func (e HttpErrorDto) Error() string {
	return e.Message
}

// GetWeddings godoc
// @Summary Get all weddings
// @Description Get a list of all weddings
// @Tags weddings
// @Accept json
// @Produce json
// @Success 200 {object} []model.Wedding
// @Router /weddings [get]
func (wc *WeddingController) GetWeddings(ctx *gin.Context) {
	weddings := wc.WeddingService.FindAll()

	ctx.Header("Content-Type", "application/json")
	ctx.JSON(http.StatusOK, weddings)
}

// CreateWedding godoc
// @Summary Create a new wedding
// @Description Create a new wedding
// @Tags weddings
// @Accept json
// @Produce json
// @Param wedding body model.Wedding true "Wedding object to be created"
// @Success 201 {object} model.Wedding
// @Failure 400 {string} string "Invalid request"
// @Router /wedding [post]
func (wc *WeddingController) CreateWedding(ctx *gin.Context) {
	var wedding model.Wedding
	if err := ctx.ShouldBindJSON(&wedding); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	createdWedding, err := wc.WeddingService.Create(wedding)
	if err.Code != 0 {
		ctx.JSON(err.Code, gin.H{"message": err.Message})
		return
	}

	ctx.JSON(http.StatusCreated, createdWedding)
}

// GetWeddingByID godoc
// @Summary Get a wedding by ID
// @Description Get a wedding by its ID
// @Tags weddings
// @Accept json
// @Produce json
// @Param id path int true "Wedding ID"
// @Success 200 {object} model.Wedding
// @Failure 404 {string} string "Wedding not found"
// @Router /weddings/{id} [get]
func (wc *WeddingController) GetWeddingByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid wedding ID"})
		return
	}

	wedding, err := wc.WeddingService.FindByID(id)
	if err != nil { // Check if there is an error
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	ctx.JSON(http.StatusOK, wedding)
}

// DeleteWeddingByID godoc
// @Summary Delete a wedding by ID
// @Description Delete a wedding by its ID
// @Tags weddings
// @Accept json
// @Produce json
// @Param id path int true "Wedding ID"
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid wedding ID"
// @Failure 404 {string} string "Wedding not found"
// @Failure 500 {string} string "Internal server error"
// @Router /weddings/{id} [delete]
func (wc *WeddingController) DeleteWeddingByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid wedding ID"})
		return
	}

	err = wc.WeddingService.Delete(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	ctx.Status(http.StatusNoContent)
}

// UpdateWedding godoc
// @Summary Update a wedding by ID
// @Description Update a wedding by its ID
// @Tags weddings
// @Accept json
// @Produce json
// @Param id path int true "Wedding ID"
// @Param wedding body model.Wedding true "Updated wedding object"
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid wedding ID or request body"
// @Failure 404 {string} string "Wedding not found"
// @Failure 500 {string} string "Internal server error"
// @Router /weddings/{id} [put]
func (wc *WeddingController) UpdateWedding(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid wedding ID"})
		return
	}

	var updatedWedding model.Wedding
	if err := ctx.ShouldBindJSON(&updatedWedding); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	wedding, updateErr := wc.WeddingService.Update(id, updatedWedding)
	if updateErr != nil {
		if strings.Contains(updateErr.Error(), "wedding not found") {
			ctx.JSON(http.StatusNotFound, gin.H{"error": updateErr.Error()})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		}
		return
	}

	// If the update was successful, return No Content
	ctx.JSON(http.StatusCreated, wedding)
}

// addWeddingOrganizer godoc
// @Summary Add a wedding organizer
// @Description Add a wedding organizer
// @Tags weddings
// @Accept json
// @Produce json
// @Param id path int true "Wedding ID"
// @Param user body model.User true "User object to be added as an organizer"
// @Success 200 {object} model.User
// @Failure 400 {string} string "Invalid request"
// @Router /weddings/{id}/organizer [post]
func (wc *WeddingController) AddWeddingOrganizer(ctx *gin.Context) {

	var body model.User
	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid wedding ID"})
		return
	}

	organizer, error := wc.WeddingService.AddWeddingOrganizer(id, body)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, gin.H{"error": error.Message})
		return
	}

	ctx.JSON(http.StatusOK, organizer)
}

// GetWeddingByUserID godoc
// @Summary Get a wedding by User ID
// @Description Get a wedding by its User ID
// @Tags weddings
// @Accept json
// @Produce json
// @Param userId path int true "User ID"
// @Success 200 {object} model.Wedding
// @Failure 404 {string} string "Wedding not found"
// @Router /weddings/user/{userId} [get]
func (wc *WeddingController) GetWeddingByUserID(ctx *gin.Context) {
	userID, err := strconv.ParseUint(ctx.Param("id"), 10, 64)

	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	wedding, err := wc.WeddingService.FindByUserID(userID)

	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	ctx.JSON(http.StatusOK, wedding)
}
