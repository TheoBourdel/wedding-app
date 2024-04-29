package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func ImageRoutes(router *gin.Engine) {
	var imageControllerPort controller_port.ImageControllerInterface = &controller.ImageController{}

	router.GET("/images", imageControllerPort.GetImages)
	router.POST("/addimage", imageControllerPort.CreateImage)
	router.GET("/image/:id", imageControllerPort.GetImageByID)
	router.DELETE("/image/:id", imageControllerPort.DeleteImageByID)
	router.PATCH("/image/:id", imageControllerPort.UpdateImage)




}
