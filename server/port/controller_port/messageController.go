package controller_port

import "github.com/gin-gonic/gin"

type MessageControllerInterface interface {
	GetMessagesByRoomID(c *gin.Context)
}
