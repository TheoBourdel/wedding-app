package service

import (
	"api/dto"
	"api/model"
	"api/repository"
)

type RoomService struct {
	Repo *repository.RoomRepository
}

func NewRoomService(repo *repository.RoomRepository) *RoomService {
	return &RoomService{Repo: repo}
}

func (svc *RoomService) CreateRoom(room model.Room) (model.Room, dto.HttpErrorDto) {
	createdRoom, err := svc.Repo.Create(room)

	if err.Code != 0 {
		return model.Room{}, err
	}

	return createdRoom, dto.HttpErrorDto{}
}

func (us *RoomService) GetRoom(id string) (model.Room, dto.HttpErrorDto) {
	room, error := us.Repo.FindOneBy("id", id)
	if error != (dto.HttpErrorDto{}) {
		return model.Room{}, error
	}

	return room, dto.HttpErrorDto{}
}

func (svc *RoomService) CreateParticipant(participant model.RoomParticipant) (model.RoomParticipant, dto.HttpErrorDto) {
	createdParticipant, err := svc.Repo.AddParticipantInRoom(participant)

	if err.Code != 0 {
		return model.RoomParticipant{}, err
	}

	return createdParticipant, dto.HttpErrorDto{}
}

func (svc *RoomService) GetAllRooms() ([]model.Room, dto.HttpErrorDto) {
	rooms, err := svc.Repo.GetAllRooms()

	if err.Code != 0 {
		return []model.Room{}, err
	}

	return rooms, dto.HttpErrorDto{}
}

func (svc *RoomService) GetParticipantsByRoomID(roomID uint) ([]model.User, dto.HttpErrorDto) {

	participants, err := svc.Repo.GetParticipantsByRoomID(roomID)

	if err.Code != 0 {
		return []model.User{}, err
	}

	return participants, dto.HttpErrorDto{}
}

func (s *RoomService) GetRoomsByUserID(userID uint) ([]model.RoomWithUsers, dto.HttpErrorDto) {
	return s.Repo.GetRoomsByUserID(userID)
}
