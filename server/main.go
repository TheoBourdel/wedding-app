package main

import (
	"api/config"
	"api/route"

	"github.com/gin-gonic/gin"

	_ "api/docs"

	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func init() {
	config.PostgresDatabaseConnection()
}

// @title Challenge API
// @version 1.0
// @description API pour le challenge de l'ESGI

// @host localhost:8080
// @BasePath /
func main() {
	// Create a new router
	router := gin.Default()
	route.UserRoutes(router)
	route.WeddingRoutes(router)
	route.ServiceRoutes(router)
	route.CategoryRoutes(router)
	route.ImageRoutes(router)
	route.AuthRoutes(router)

	// Swagger
	router.GET("/docs/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// Run the server
	router.Run(":8080")
}
