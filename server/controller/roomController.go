package controller

// import (
// 	"api/model"
// 	"api/service"
// 	"net/http"

// 	"github.com/gin-gonic/gin"
// )

// type RoomController struct {
// 	RoomService *service.RoomService
// }

// func (rc *RoomController) CreateRoom(ctx *gin.Context) {
// 	var req model.CreateRoomReq
// 	if err := ctx.ShouldBindJSON(&req); err != nil {
// 		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
// 		return
// 	}

// 	room := model.Room{
// 		RoomName: req.Name,
// 	}

// 	room, err := rc.RoomService.CreateRoom(room)
// 	if err != nil {
// 		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
// 		return
// 	}

// 	ctx.JSON(http.StatusOK, room)
// }
