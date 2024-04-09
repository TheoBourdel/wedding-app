package config

import (
	"fmt"
	"os"

	"github.com/joho/godotenv"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func PostgresDatabaseConnection() *gorm.DB {
	err := godotenv.Load(".env")
	if err != nil {
		panic("Error loading .env file: %s")
	}

	dsn := os.Getenv("DB_URL")

	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic("Failed to connect to database!")
	} else {
		fmt.Println("Connected to database!")
	}

	return DB
}
