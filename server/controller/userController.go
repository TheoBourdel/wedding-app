package controller

import (
	"net/http"

	_ "api/docs"
	"api/service"

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
