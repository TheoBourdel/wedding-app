package controller

import (
	"fmt"
	"net/http"
	"strconv"

	_ "api/docs"
	"api/dto"
	"api/model"
	"api/service"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	UserService    service.UserService
	WeddingService service.WeddingService
}

// GetUsers godoc
// @Summary Get all users
// @Description Get a list of all users
// @Tags users
// @Accept json
// @Produce json
// @Security BearerAuth
// @Success 200 {object} []model.User
// @Router /users [get]
func (uc *UserController) GetUsers(ctx *gin.Context) {
	page, _ := strconv.Atoi(ctx.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(ctx.DefaultQuery("pageSize", "10"))
	query := ctx.DefaultQuery("query", "")

	users := uc.UserService.FindAll(page, pageSize, query)
	ctx.Header("Content-Type", "application/json")
	ctx.JSON(http.StatusOK, users)
}

func (uc *UserController) CreateUserEstimate(ctx *gin.Context) {
	var body dto.CreateEstimateDto
	fmt.Println("CreateUserEstimate", ctx.Bind(body.ServiceID))

	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(400, gin.H{"error": "Invalid ID"})
		return
	}

	estimate, error := uc.UserService.CreateEstimate(id, body)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.JSON(http.StatusOK, estimate)
}

// GetUserEstimates godoc
// @Summary Get all estimates for a user
// @Description Get all estimates for a user
// @Tags users
// @Accept json
// @Produce json
// @Param id path int true "User ID"
// @Security Bearer
// @Router /user/{id}/estimates [get]
func (uc *UserController) GetUserEstimates(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(400, gin.H{"error": "Invalid ID"})
		return
	}

	estimates, error := uc.UserService.GetUserEstimates(id)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.JSON(http.StatusOK, estimates)
}

// CreateUser godoc
// @Summary Create a user
// @Description Create a new user
// @Tags users
// @Accept json
// @Produce json
// @Param user body model.User true "User object"
// @Success 201 {object} model.User
// @Router /user [post]
func (uc *UserController) CreateUser(ctx *gin.Context) {
	var body model.User
	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	user, err := uc.UserService.CreateUser(body)
	if err != (dto.HttpErrorDto{}) {
		ctx.JSON(err.Code, err)
		return
	}

	ctx.JSON(http.StatusCreated, user)
}

func (uc *UserController) GetUser(ctx *gin.Context) {
	id := ctx.Param("id")

	user, error := uc.UserService.GetUser(id)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.Header("Content-Type", "application/json")
	ctx.JSON(http.StatusOK, user)
}

func (uc *UserController) UpdateUserFirebaseToken(ctx *gin.Context) {
	id := ctx.Param("id")
	userID, err := strconv.ParseUint(id, 10, 32)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}
	var body struct {
		Token string `json:"token"`
	}
	if err := ctx.BindJSON(&body); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	user, updateErr := uc.UserService.UpdateUserFirebaseToken(uint(userID), body.Token)
	if updateErr != (dto.HttpErrorDto{}) {
		ctx.JSON(updateErr.Code, updateErr)
		return
	}

	ctx.JSON(http.StatusOK, user)
}

func (uc *UserController) DeleteUser(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	err = uc.UserService.DeleteUserByID(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete user"})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"message": "User deleted successfully"})
}

func (uc *UserController) GetWeddingIdByUserId(ctx *gin.Context) {
	userIdStr := ctx.Param("id")
	userId, err := strconv.ParseUint(userIdStr, 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	wedding, err := uc.WeddingService.FindByUserID(userId)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	if wedding == nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "No wedding found"})
		return
	}

	//ctx.JSON(http.StatusOK, gin.H{"wedding_id": wedding.ID})
}

func (uc *UserController) UpdateUser(ctx *gin.Context) {
	var body model.User
	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	user, error := uc.UserService.UpdateUser(body)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, error)
		return
	}

	ctx.JSON(http.StatusOK, user)
}
