package ws

import (
	"api/config"
	"api/model"

	"api/repository"
	"api/service"

	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

type Handler struct {
	hub *Hub
}

func NewHandler(h *Hub) *Handler {
	return &Handler{
		hub: h,
	}
}

func (h *Handler) CreateRoom(c *gin.Context) {
	var req model.CreateRoomReq
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	room := model.Room{
		RoomName: req.Name,
	}

	if result := config.DB.Create(&room); result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": result.Error.Error()})
		return
	}

	h.hub.Rooms[fmt.Sprintf("%d", room.ID)] = &Room{
		ID:           fmt.Sprintf("%d", room.ID),
		Name:         room.RoomName,
		SessionChats: make(map[string]*SessionChat),
	}

	c.JSON(http.StatusOK, room)
}

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func (h *Handler) JoinRoom(c *gin.Context) {
	conn, err := upgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	roomID := c.Param("roomId")
	userID := c.Query("userId")

	var user model.User
	if result := config.DB.First(&user, "id = ?", userID); result.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}
	var room model.Room
	if result := config.DB.First(&room, "id = ?", roomID); result.Error != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room not found"})
		return
	}
	participant := model.RoomParticipant{
		RoomID: room.ID,
		UserID: user.ID,
	}
	if result := config.DB.Create(&participant); result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": result.Error.Error()})
		return
	}
	roomIDStr := strconv.FormatUint(uint64(room.ID), 10)
	userIDStr := strconv.FormatUint(uint64(user.ID), 10)

	msgRepository := repository.NewMessageRepository(config.DB)
	msgService := service.NewMessageService(msgRepository)
	// msgService := service.NewMessageService(config.DB)

	cl := &SessionChat{
		Conn:       conn,
		Message:    make(chan *model.Message, 10),
		RoomID:     roomIDStr,
		UserID:     userIDStr,
		MsgService: msgService,
	}

	m := &model.Message{
		Content: "A new user has joined the room",
		RoomID:  uint(room.ID),
	}

	log.Println(m.Content)

	h.hub.Register <- cl
	h.hub.Broadcast <- m

	go cl.writeMessage()
	cl.readMessage(h.hub)

	c.JSON(http.StatusOK, gin.H{"message": "Joined room successfully"})
}

func (h *Handler) GetRooms(c *gin.Context) {
	var roomsInDB []model.Room
	if result := config.DB.Find(&roomsInDB); result.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to load rooms from database"})
		return
	}

	for _, room := range roomsInDB {
		if _, exists := h.hub.Rooms[fmt.Sprintf("%d", room.ID)]; !exists {
			h.hub.Rooms[fmt.Sprintf("%d", room.ID)] = &Room{
				ID:           fmt.Sprintf("%d", room.ID),
				Name:         room.RoomName,
				SessionChats: make(map[string]*SessionChat),
			}
		}
	}

	rooms := make([]model.RoomRes, 0)
	for _, r := range h.hub.Rooms {
		rooms = append(rooms, model.RoomRes{
			ID:   r.ID,
			Name: r.Name,
		})
	}

	c.JSON(http.StatusOK, rooms)
}

func (h *Handler) GetSessionChats(c *gin.Context) {
	var SessionChats []model.SessionChatRes
	roomId := c.Param("roomId")

	if _, ok := h.hub.Rooms[roomId]; !ok {
		SessionChats = make([]model.SessionChatRes, 0)
		c.JSON(http.StatusOK, SessionChats)
	}

	for _, c := range h.hub.Rooms[roomId].SessionChats {
		SessionChats = append(SessionChats, model.SessionChatRes{
			ID:     c.ID,
			UserId: c.UserID,
		})
	}

	c.JSON(http.StatusOK, SessionChats)
}

func parseUint(s string) uint {
	u, err := strconv.ParseUint(s, 10, 32)
	if err != nil {
		log.Printf("Error parsing uint from string: %v", err)
		return 0
	}
	return uint(u)
}
