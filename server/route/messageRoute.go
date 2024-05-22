package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func MessageRoutes(router *gin.Engine) {
	var MessageControllerPort controller_port.MessageControllerInterface = &controller.MessageController{}

	router.GET("/room/:id/messages", MessageControllerPort.GetMessagesByRoomID)
}
