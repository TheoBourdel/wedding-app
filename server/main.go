package main

import (
	"api/config"
	"api/route"
	"api/ws"
	"time"

	"github.com/gin-contrib/cors"
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

	// Configure CORS middleware
	router.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"http://localhost:62622", "http://127.0.0.1:62622", "http://127.0.0.1:8080"}, // Ajoutez vos origines autorisées ici
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Accept", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           12 * time.Hour,
	}))

	// Define routes
	route.UserRoutes(router)
	route.WeddingRoutes(router)
	route.ServiceRoutes(router)
	route.CategoryRoutes(router)
	route.ImageRoutes(router)
	route.AuthRoutes(router)
	route.MessageRoutes(router)
	route.StatisticsRoutes(router)
	route.HistoryRoutes(router)
	route.EstimateRoutes(router)
	route.OrganizerRoutes(router)

	// WebSocket
	hub := ws.NewHub()
	hub.LoadRoomsFromDB()
	handler := ws.NewHandler(hub)
	route.WSRoutes(router, handler)
	go hub.Run()

	// Swagger
	router.GET("/docs/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// Run the server on port 8080
	if err := router.Run("0.0.0.0:8080"); err != nil {
		panic(err) // Log the error if the server fails to start
	}
}
