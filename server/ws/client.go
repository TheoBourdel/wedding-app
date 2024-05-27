package ws

import (
	"api/model"
	"api/service"
	"log"
	"strconv"
	"time"

	"github.com/gorilla/websocket"
)

type SessionChat struct {
	Conn        *websocket.Conn
	Message     chan *model.Message
	ID          string `json:"id"`
	RoomID      string `json:"roomId"`
	UserID      string `json:"userId"`
	OtherUserID string `json:"otherUserId"`
	MsgService  *service.MessageService
}

func (c *SessionChat) writeMessage() {
	defer func() {
		c.Conn.Close()
	}()

	for {
		message, ok := <-c.Message
		if !ok {
			return
		}

		c.Conn.WriteJSON(message)
	}
}

func (c *SessionChat) readMessage(hub *Hub) {
	defer func() {
		hub.Unregister <- c
		c.Conn.Close()
	}()

	for {
		_, m, err := c.Conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				log.Printf("WebSocket error: %v", err)
			} else {
				log.Printf("Read error: %v", err)
			}
			break
		}

		userIDUint, err := strconv.ParseUint(c.UserID, 10, 64)
		if err != nil {
			log.Printf("Failed to convert UserID to uint: %v", err)
			continue
		}

		roomIDUint, err := strconv.ParseUint(c.RoomID, 10, 64)
		if err != nil {
			log.Printf("Failed to convert RoomID to uint: %v", err)
			continue
		}

		msg := &model.Message{
			Content:   string(m),
			RoomID:    uint(roomIDUint),
			UserID:    uint(userIDUint),
			CreatedAt: time.Now(),
		}
		hub.Broadcast <- msg
		savedMessage, errDto := c.MsgService.SaveMessage(*msg)
		if errDto.Code != 0 {
			log.Printf("Failed to save message: %s", errDto.Message)
		} else {
			log.Printf("Message saved successfully: %+v", savedMessage)
		}
	}
}
