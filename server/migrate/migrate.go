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
	fmt.Println("Migration has been processed!")
}
