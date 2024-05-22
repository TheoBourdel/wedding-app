package controller_port

import "github.com/gin-gonic/gin"

type WsControllerInterface interface {
	CreateRoom(c *gin.Context)
	JoinRoom(c *gin.Context)
	GetRooms(c *gin.Context)
	GetSessionChats(c *gin.Context)
}
