package controller

import (
	"net/http"
	"strconv"

	_ "api/docs"
	"api/dto"
	"api/service"
	"api/model"

	"github.com/gin-gonic/gin"
)

type UserController struct {
	UserService service.UserService
}

// GetUsers godoc
// @Summary Get all users
// @Description Get a list of all users
// @Tags users
// @Accept json
// @Produce json
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