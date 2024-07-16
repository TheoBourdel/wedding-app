package route

import (
	"api/controller"
	"api/middelware"
	"api/port/controller_port"
	"api/config"
	"api/repository"
	"api/service"

	"github.com/gin-gonic/gin"
)

func UserRoutes(router *gin.Engine) {
	// Initialiser les repositories
	userRepo := repository.UserRepository{DB: config.DB}
	weddingRepo := repository.WeddingRepository{DB: config.DB}

	// Initialiser les services
	userService := service.UserService{UserRepository: userRepo}
	weddingService := service.WeddingService{WeddingRepository: weddingRepo, UserRepository: userRepo}

	// Initialiser le contrôleur
	userController := &controller.UserController{
		UserService:    userService,
		WeddingService: weddingService,
	}

	var userControllerPort controller_port.UserControllerInterface = userController

	// Auth & Admin
	router.GET("/users", middelware.RequireAuthAndAdmin, userControllerPort.GetUsers)
	router.DELETE("/users/:id", middelware.RequireAuthAndAdmin, userControllerPort.DeleteUser)
	router.PATCH("/user/:userId",middelware.RequireAuthAndAdmin,  userControllerPort.UpdateUser)

	// Auth
	router.GET("/user/:id/weddingId",middelware.RequireAuth, userControllerPort.GetWeddingIdByUserId)
	
	router.POST("/user", userControllerPort.CreateUser)
	router.GET("/user/:id", userControllerPort.GetUser)
	router.POST("/user/:id/estimate", userControllerPort.CreateUserEstimate)
	router.GET("/user/:id/estimates", userControllerPort.GetUserEstimates)
	router.PUT("/user/:id/token", userControllerPort.UpdateUserFirebaseToken)
}
