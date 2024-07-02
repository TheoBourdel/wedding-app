package controller

import (
	_ "api/docs"
	"api/dto"
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
// @Failure 400 {string} string "Invalid request"
// @Failure 500 {string} string "Server error"
// @Router /signup [post]
func (ac *AuthController) SignUp(ctx *gin.Context) {

	var body model.User
	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}
	if body.Role == "admin" {
		ctx.JSON(400, gin.H{"error": "Bien essayé, mais non."})
		return
	}

	user, error := ac.AuthService.SignUp(body)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, gin.H{"error": error.Message})
		return
	}

	ctx.JSON(http.StatusOK, user)

}

// SignIn godoc
// @Summary Sign in
// @Description Sign in a user
// @Tags auth
// @Accept json
// @Produce json
// @Success 200
// @Failure 401 {string} string "Invalid password"
// @Failure 404 {string} string "User not found"
// @Failure 500 {string} string "Server error"
// @Router /signin [post]
func (ac *AuthController) SignIn(ctx *gin.Context) {

	var body dto.SignInDto
	if ctx.Bind(&body) != nil {
		ctx.JSON(400, gin.H{"error": "Invalid request"})
		return
	}

	token, error := ac.AuthService.SignIn(body)
	if error != (dto.HttpErrorDto{}) {
		ctx.JSON(error.Code, gin.H{"error": error.Message})
		return
	}

	//ctx.SetSameSite(http.SameSiteLaxMode)
	ctx.SetCookie("Authorization", token, 3600*24*30, "", "", false, true)
	ctx.JSON(http.StatusOK, token)
}

// SignOut godoc
// @Summary Sign out
// @Description Sign out a user
// @Tags auth
// @Accept json
// @Produce json
// @Success 204
// @Router /signout [delete]
func (ac *AuthController) SignOut(ctx *gin.Context) {

	ctx.SetCookie("Authorization", "", -1, "", "", false, true)
	ctx.JSON(http.StatusNoContent, gin.H{})

}
