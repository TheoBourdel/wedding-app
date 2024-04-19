package main

import (
	"api/config"
	"api/model"
	"fmt"
)

func init() {
	config.PostgresDatabaseConnection()
}

func main() {
	config.DB.AutoMigrate(&model.User{})
	config.DB.AutoMigrate(&model.Wedding{})

	fmt.Println("Migration has been processed!")
}
