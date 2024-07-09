package main

import (
	"api/config"
	_ "api/docs"
	"api/route"
	"api/ws"
	"strings"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"

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

	// Configure CORS middleware with dynamic origin check
	router.Use(cors.New(cors.Config{
		AllowOriginFunc: func(origin string) bool {
			// Allow any origin from localhost with any port
			return strings.HasPrefix(origin, "http://localhost:") || strings.HasPrefix(origin, "http://127.0.0.1:") || strings.HasPrefix(origin, "https://challenge.mlk-labs.com:") || origin == "http://wedding-app-web.s3-website.eu-north-1.amazonaws.com"
		},
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
