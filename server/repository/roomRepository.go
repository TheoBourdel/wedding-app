package repository

import (
	"api/config"
	"api/dto"
	"api/model"
	"fmt"

	"gorm.io/gorm"
)

type RoomRepository struct {
	DB *gorm.DB
}

func NewRoomRepository(db *gorm.DB) *RoomRepository {
	return &RoomRepository{DB: db}
}

func (repo *RoomRepository) Create(room model.Room) (model.Room, dto.HttpErrorDto) {

	result := repo.DB.Create(&room).Error

	if result != nil && result.Error != nil {
		return model.Room{}, dto.HttpErrorDto{Message: "Error while creating image", Code: 500}
	}
	return room, dto.HttpErrorDto{}
}

func (ur *RoomRepository) FindOneBy(field string, value string) (model.Room, dto.HttpErrorDto) {
	var room model.Room

	result := config.DB.Where(field+" = ?", value).First(&room)
	if result.RowsAffected == 0 {
		return model.Room{}, dto.HttpErrorDto{Message: "room not found", Code: 404}
	}

	if result.Error != nil {
		return model.Room{}, dto.HttpErrorDto{Message: "Error while fetching room", Code: 500}
	}

	return room, dto.HttpErrorDto{}
}

func (repo *RoomRepository) AddParticipantInRoom(participant model.RoomParticipant) (model.RoomParticipant, dto.HttpErrorDto) {
	result := repo.DB.Create(&participant)
	if result != nil && result.Error != nil {
		return model.RoomParticipant{}, dto.HttpErrorDto{Message: "Error while creating image", Code: 500}
	}
	return participant, dto.HttpErrorDto{}
}

func (repo *RoomRepository) GetAllRooms() ([]model.Room, dto.HttpErrorDto) {
	var rooms []model.Room
	result := repo.DB.Find(&rooms)
	if result != nil && result.Error != nil {
		return []model.Room{}, dto.HttpErrorDto{Message: "Error while creating image", Code: 500}
	}
	return rooms, dto.HttpErrorDto{}
}

func (repo *RoomRepository) GetParticipantsByRoomID(roomID uint) ([]model.User, dto.HttpErrorDto) {
	var participants []model.User

	result := repo.DB.
		Model(&model.User{}).
		Joins("INNER JOIN room_participants ON room_participants.user_id = users.id").
		Where("room_participants.room_id = ?", roomID).
		Find(&participants)

	if result.Error != nil {
		return nil, dto.HttpErrorDto{Message: "Error fetching participants", Code: 500}
	}

	return participants, dto.HttpErrorDto{}

}

func (repo *RoomRepository) GetRoomsByUserID(userID uint) ([]model.RoomWithUsers, dto.HttpErrorDto) {
	var rooms []model.Room

	subQuery := repo.DB.
		Table("room_participants").
		Select("room_id").
		Where("user_id = ?", userID)

	mainQuery := repo.DB.
		Table("rooms").
		Where("id IN (?)", subQuery)

	result := mainQuery.Find(&rooms)

	if result.Error != nil {
		return nil, dto.HttpErrorDto{Message: "Error fetching rooms", Code: 500}
	}

	var roomsWithUsers []model.RoomWithUsers

	for _, room := range rooms {
		var participants []model.RoomWithUsers
		userResult := repo.DB.
			Table("users").
			Select("rooms.id as id, rooms.room_name, rooms.id as room_id, users.id as user_id, users.firstname, users.lastname, users.email").
			Joins("INNER JOIN room_participants ON room_participants.user_id = users.id").
			Joins("INNER JOIN rooms ON room_participants.room_id = rooms.id").
			Where("room_participants.room_id = ?", room.ID).
			Where("users.id != ?", userID).
			Scan(&participants)

		if userResult.Error != nil {
			return nil, dto.HttpErrorDto{Message: "Error fetching users in room", Code: 500}
		}
		roomsWithUsers = append(roomsWithUsers, participants...)

	}

	var filteredRooms = filterUniqueItems(roomsWithUsers)
	fmt.Println(filteredRooms)

	return filteredRooms, dto.HttpErrorDto{}
}

func filterUniqueItems(items []model.RoomWithUsers) []model.RoomWithUsers {
	seen := make(map[int]bool)
	var result []model.RoomWithUsers

	for _, item := range items {
		if !seen[int(item.ID)] {
			seen[int(item.ID)] = true
			result = append(result, item)
		}
	}
	return result
}

func (s *RoomRepository) AddParticipant(participant model.RoomParticipant) error {
	if err := s.DB.Create(&participant).Error; err != nil {
		return err
	}
	return nil
}

func (s *RoomRepository) CheckRoomExistsForUsers(user1ID, user2ID uint) (bool, model.Room, dto.HttpErrorDto) {
	var room model.Room
	err := s.DB.Raw(`
		SELECT r.*
		FROM rooms r
		JOIN room_participants rp1 ON rp1.room_id = r.id
		JOIN room_participants rp2 ON rp2.room_id = r.id
		WHERE rp1.user_id = ? AND rp2.user_id = ?`, user1ID, user2ID).Scan(&room).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return false, model.Room{}, dto.HttpErrorDto{}
		}
		return false, model.Room{}, dto.HttpErrorDto{
			Message: "Internal server error",
		}
	}
	return true, room, dto.HttpErrorDto{}
}