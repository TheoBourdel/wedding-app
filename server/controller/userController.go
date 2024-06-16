package controller

import (
	"fmt"
	"net/http"

	_ "api/docs"
	"api/dto"
	"api/model"
	"api/service"

	"strconv"

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
	users := uc.UserService.FindAll()

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

func (uc *UserController) CreateUser(ctx *gin.Context) {

	var body model.User
	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

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
