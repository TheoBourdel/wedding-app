package repository

import (
	"api/config"
	"api/dto"
	"api/model"

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

// func (repo *RoomRepository) GetRoomsByUserID(userID uint) ([]model.RoomWithUsers, dto.HttpErrorDto) {
// 	var rooms []model.RoomWithUsers

// 	result := repo.DB.
// 		Table("rooms").
// 		Select("rooms.id, rooms.room_name, users.id as user_id, users.firstname, users.lastname, users.email").
// 		Joins("INNER JOIN room_participants ON room_participants.room_id = rooms.id").
// 		Joins("INNER JOIN users ON room_participants.user_id = users.id").
// 		Where("room_participants.user_id = ?", userID).
// 		Scan(&rooms)

// 	if result.Error != nil {
// 		return nil, dto.HttpErrorDto{Message: "Error fetching rooms and users", Code: 500}
// 	}

// 	return rooms, dto.HttpErrorDto{}
// }

func (repo *RoomRepository) GetRoomsByUserID(userID uint) ([]model.RoomWithUsers, dto.HttpErrorDto) {
	var rooms []model.RoomWithUsers

	// Subquery to find rooms the user is part of
	subQuery := repo.DB.
		Table("room_participants").
		Select("room_id").
		Where("user_id = ?", userID)

	// Main query to find users in those rooms, excluding the given user
	result := repo.DB.
		Table("rooms").
		Select("rooms.id as room_id, rooms.room_name, users.id as user_id, users.firstname, users.lastname, users.email").
		Joins("INNER JOIN room_participants ON room_participants.room_id = rooms.id").
		Joins("INNER JOIN users ON room_participants.user_id = users.id").
		Where("rooms.id IN (?)", subQuery).
		Where("users.id != ?", userID).
		Scan(&rooms)

	if result.Error != nil {
		return nil, dto.HttpErrorDto{Message: "Error fetching rooms and users", Code: 500}
	}

	return rooms, dto.HttpErrorDto{}
}
