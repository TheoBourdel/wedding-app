package utils

import (
	"fmt"
	"math/rand"
	"time"
)

type PasswordGenerator struct {
}

func (pg *PasswordGenerator) GenerateRandomPassword(length int) string {
	fmt.Println("Generating password")
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

	rand.Seed(time.Now().UnixNano())

	password := make([]byte, length)
	for i := range password {
		password[i] = charset[rand.Intn(len(charset))]
	}
	return string(password)
}
