package ws

import (
	"api/config"
	"api/dto"
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
	hub         *Hub
	RoomService *service.RoomService
	UserService service.UserService
}

func NewHandler(h *Hub) *Handler {
	roomRepo := repository.NewRoomRepository(config.DB)
	roomService := service.NewRoomService(roomRepo)
	return &Handler{
		hub:         h,
		RoomService: roomService,
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

	if h.RoomService == nil {
		log.Fatal("RoomService is not initialized")
	}

	createdRoom, err := h.RoomService.CreateRoom(room)
	if err.Code != 0 {
		log.Printf("Failed to save message: %s", err.Message)
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create room"})
		return
	}

	// Ajouter les participants à la table room_participants
	for _, userID := range req.UserIDs {
		participant := model.RoomParticipant{
			RoomID: createdRoom.ID,
			UserID: userID,
		}
		errDto := h.RoomService.AddParticipant(participant)
		if errDto.Code != 0 {
			log.Printf("Failed to add participant: %s", errDto.Message)
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to add participant"})
			return
		}
	}

	h.hub.Rooms[fmt.Sprintf("%d", createdRoom.ID)] = &Room{
		ID:           fmt.Sprintf("%d", createdRoom.ID),
		Name:         createdRoom.RoomName,
		SessionChats: make(map[string]*SessionChat),
	}

	c.JSON(http.StatusOK, createdRoom)
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

	fmt.Printf("eee")

	roomID := c.Param("roomId")
	userID := c.Query("userId")

	user, errDto := h.UserService.GetUser(userID)
	if errDto != (dto.HttpErrorDto{}) {
		c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
		return
	}

	room, errDto := h.RoomService.GetRoom(roomID)
	if errDto != (dto.HttpErrorDto{}) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room not found"})
		return
	}

	participant := model.RoomParticipant{
		RoomID: room.ID,
		UserID: user.ID,
	}

	cp, errDto := h.RoomService.CreateParticipant(participant)
	if errDto != (dto.HttpErrorDto{}) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Room not found"})
		return
	} else {
		fmt.Println(cp)
	}

	roomIDStr := strconv.FormatUint(uint64(room.ID), 10)
	userIDStr := strconv.FormatUint(uint64(user.ID), 10)

	msgRepository := repository.NewMessageRepository(config.DB)
	msgService := service.NewMessageService(msgRepository)

	cl := &SessionChat{
		Conn:       conn,
		Message:    make(chan *model.Message, 10),
		RoomID:     roomIDStr,
		UserID:     userIDStr,
		MsgService: msgService,
	}

	m := &model.Message{
		Content: "",
		RoomID:  uint(room.ID),
	}

	h.hub.Register <- cl
	h.hub.Broadcast <- m

	go cl.writeMessage()
	cl.readMessage(h.hub)

	c.JSON(http.StatusOK, gin.H{"message": "Joined room successfully"})
}

func (h *Handler) GetRooms(c *gin.Context) {
	allRooms, err := h.RoomService.GetAllRooms()
	if err != (dto.HttpErrorDto{}) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Failed to load rooms from database"})
		return
	}
	for _, room := range allRooms {
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
	roomId, err := strconv.ParseUint(c.Param("roomId"), 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid room ID"})
		return
	}

	participants, cerr := h.RoomService.GetParticipantsByRoomID(uint(roomId))

	if cerr != (dto.HttpErrorDto{}) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Failed to load participants from database"})
		return
	}

	sessionChats := make([]model.User, 0)
	for _, participant := range participants {
		sessionChats = append(sessionChats, model.User{
			Firstname: participant.Firstname,
		})
	}

	c.JSON(http.StatusOK, participants)
}

func (h *Handler) GetRoomsByUser(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user ID"})
		return
	}

	rooms, cerr := h.RoomService.GetRoomsByUserID(uint(userID))
	if cerr != (dto.HttpErrorDto{}) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Failed to load participants from database"})
		return
	}

	c.JSON(http.StatusOK, rooms)
}
func parseUint(s string) uint {
	u, err := strconv.ParseUint(s, 10, 32)
	if err != nil {
		log.Printf("Error parsing uint from string: %v", err)
		return 0
	}
	return uint(u)
}
