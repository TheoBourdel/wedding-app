package ws

import (
	"api/config"
	"api/model"
	"log"
	"strconv"
)

type Room struct {
	ID           string                  `json:"id"`
	Name         string                  `json:"name"`
	SessionChats map[string]*SessionChat `json:"sessionChats"`
}

type Hub struct {
	Rooms      map[string]*Room
	Register   chan *SessionChat
	Unregister chan *SessionChat
	Broadcast  chan *model.Message
}

func NewHub() *Hub {
	return &Hub{
		Rooms:      make(map[string]*Room),
		Register:   make(chan *SessionChat),
		Unregister: make(chan *SessionChat),
		Broadcast:  make(chan *model.Message, 5),
	}
}

func (h *Hub) LoadRoomsFromDB() {
	var rooms []model.Room
	if result := config.DB.Find(&rooms); result.Error != nil {
		log.Printf("Error loading rooms: %v", result.Error)
		return
	}

	for _, room := range rooms {
		roomIDStr := strconv.FormatUint(uint64(room.ID), 10)
		if _, exists := h.Rooms[roomIDStr]; !exists {
			h.Rooms[roomIDStr] = &Room{
				ID:           roomIDStr,
				Name:         room.RoomName,
				SessionChats: make(map[string]*SessionChat),
			}
		}
	}
}

func (h *Hub) Run() {

	for {
		select {
		case cl := <-h.Register:
			room, exists := h.Rooms[cl.RoomID]
			if !exists {
				log.Printf("Room %s not found on register", cl.RoomID)
				continue
			}
			room.SessionChats[cl.UserID] = cl
			log.Printf("User %s joined room %s", cl.UserID, cl.RoomID)

		case cl := <-h.Unregister:

			userIDUint, _ := strconv.ParseUint(cl.UserID, 10, 64)
			roomIDUint, _ := strconv.ParseUint(cl.RoomID, 10, 64)

			if _, ok := h.Rooms[cl.RoomID]; ok {
				if _, ok := h.Rooms[cl.RoomID].SessionChats[cl.ID]; ok {
					if len(h.Rooms[cl.RoomID].SessionChats) != 0 {
						h.Broadcast <- &model.Message{
							Content: "user left the chat",
							RoomID:  uint(userIDUint),
							UserID:  uint(roomIDUint),
						}
					}

					delete(h.Rooms[cl.RoomID].SessionChats, cl.ID)
					close(cl.Message)
				}
			}
		case m := <-h.Broadcast:
			roomIDStr := strconv.Itoa(int(m.RoomID))
			if room, ok := h.Rooms[roomIDStr]; ok {

				for _, cl := range room.SessionChats {
					log.Printf("Broadcasting message to: %s", cl.UserID)
					cl.Message <- m
				}
			} else {
				log.Printf("Room not found for broadcasting: %s, message: '%s'", roomIDStr, m)
			}
		}
	}
}
