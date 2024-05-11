package route

import (
	"api/port/controller_port"
	"api/ws"

	"github.com/gin-gonic/gin"
)

func WSRoutes(router *gin.Engine, handler *ws.Handler) {
	var wsHandler controller_port.WsControllerInterface = handler

	router.POST("/ws/createRoom", wsHandler.CreateRoom)
	router.GET("/ws/joinRoom/:roomId", wsHandler.JoinRoom)
	router.GET("/ws/getRooms", wsHandler.GetRooms)
	router.GET("/ws/getClients/:roomId", wsHandler.GetSessionChats)
}
