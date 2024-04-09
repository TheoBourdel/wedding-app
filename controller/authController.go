package controller

import (
	_ "api/docs"
	"api/model"
	"api/service"
	"net/http"

	"github.com/gin-gonic/gin"
)

type AuthController struct {
	AuthService service.AuthService
}

// SignUp godoc
// @Summary Sign up
// @Description Sign up a new user
// @Tags auth
// @Accept json
// @Produce json
// @Success 200 {object} model.User
// @Router /signup [post]
func (ac *AuthController) SignUp(ctx *gin.Context) {

	var body model.User

	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	user := ac.AuthService.SignUp(body)

	ctx.Header("Content-Type", "application/json")
	ctx.JSON(http.StatusOK, user)
}

func (ac *AuthController) SignIn(ctx *gin.Context) {

	var body 

}
