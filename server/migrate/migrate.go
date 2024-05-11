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
	config.DB.AutoMigrate(&model.Service{})
	config.DB.AutoMigrate(&model.Category{})
	config.DB.AutoMigrate(&model.Image{})
	config.DB.AutoMigrate(&model.Room{})
	config.DB.AutoMigrate(&model.Message{})
	config.DB.AutoMigrate(&model.RoomParticipant{})

	fmt.Println("Migration has been processed!")
}
