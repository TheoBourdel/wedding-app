package controller

import (
	"net/http"
	"strconv"

	"api/service"

	"github.com/gin-gonic/gin"
)

type MessageController struct {
	MessageService service.MessageService
}

// GetMessagesByRoomID godoc
// @Summary Get messages by room ID
// @Description Get a list of messages for a specified room
// @Tags messages
// @Security Bearer
// @Accept json
// @Produce json
// @Param room_id path int true "Room ID"
// @Success 200 {object} []model.Message
// @Router /room/{room_id}/messages [get]
func (mc *MessageController) GetMessagesByRoomID(ctx *gin.Context) {
	roomID, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "invalid room ID provided"})
		return
	}

	messages, err := mc.MessageService.FindByID(uint(roomID))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, messages)
}
