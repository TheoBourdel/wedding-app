package tests

import (
	"regexp"
	"testing"
	"time"

	"github.com/DATA-DOG/go-sqlmock"
	"api/service"
	"api/model"
	"api/repository"
)


func TestSaveMessage(t *testing.T) {
	db, mock := setupTestDB(t)
	repo := &repository.MessageRepository{DB: db}
	messageService := service.NewMessageService(repo)

	newMessage := model.Message{
		RoomID:  1,
		UserID:  1,
		Content: "Test message",
	}

	mock.ExpectBegin()
	mock.ExpectExec(regexp.QuoteMeta(`INSERT INTO "messages" ("room_id","user_id","content","created_at","updated_at","deleted_at") VALUES ($1,$2,$3,$4,$5,$6) RETURNING "id"`)).
		WithArgs(newMessage.RoomID, newMessage.UserID, newMessage.Content, sqlmock.AnyArg(), sqlmock.AnyArg(), nil).
		WillReturnResult(sqlmock.NewResult(1, 1))
	mock.ExpectCommit()

	createdMessage, err := messageService.SaveMessage(newMessage)
	if err.Code != 0 {
		t.Fatalf("failed to save message: %v", err.Message)
	}

	if createdMessage.Content != newMessage.Content {
		t.Errorf("expected message content to be %s, got %s", newMessage.Content, createdMessage.Content)
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}

func TestFindByID(t *testing.T) {
	db, mock := setupTestDB(t)
	repo := repository.NewMessageRepository(db)
	messageService := service.NewMessageService(repo)

	roomID := uint(1)

	mock.ExpectQuery(regexp.QuoteMeta(`SELECT * FROM "messages" WHERE room_id = $1 AND "messages"."deleted_at" IS NULL`)).
		WithArgs(roomID).
		WillReturnRows(sqlmock.NewRows([]string{"id", "room_id", "user_id", "content", "created_at", "updated_at"}).
			AddRow(1, roomID, 1, "Test message 1", time.Now(), time.Now()).
			AddRow(2, roomID, 2, "Test message 2", time.Now(), time.Now()))

	messages, err := messageService.FindByID(roomID)
	if err != nil {
		t.Fatalf("failed to find messages: %v", err)
	}

	if len(messages) != 2 {
		t.Errorf("expected 2 messages, got %d", len(messages))
	}

	expectedContents := []string{"Test message 1", "Test message 2"}
	for i, message := range messages {
		if message.Content != expectedContents[i] {
			t.Errorf("expected message content to be %s, got %s", expectedContents[i], message.Content)
		}
	}

	if err := mock.ExpectationsWereMet(); err != nil {
		t.Errorf("there were unfulfilled expectations: %v", err)
	}
}
