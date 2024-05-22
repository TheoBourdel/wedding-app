package mailer

import (
	"bytes"
	"html/template"
	"net/smtp"
	"os"

	"github.com/joho/godotenv"
)

type Mailer struct {
}

func (m *Mailer) SendMail(
	to string,
	subject string,
	templatePath string,
	data interface{},
) (isSended bool) {
	// Load the .env file
	err := godotenv.Load(".env")
	if err != nil {
		return false
	}
	// Get the mail password from the environment
	password := os.Getenv("MAIL_PASSWORD")

	// Create the email body
	var body bytes.Buffer
	template, err := template.ParseFiles(templatePath)
	if err != nil {
		return false
	}
	template.Execute(&body, data)

	// Authenticate to the smtp server
	auth := smtp.PlainAuth(
		"",
		"weedy.challenge@gmail.com",
		password,
		"smtp.gmail.com",
	)

	// Create the email message
	headers := "MIME-version: 1.0;\nContent-Type: text/html; charset=\"UTF-8\";\n\n"
	message := "Subject: " + subject + "\n" + headers + "\n\n" + body.String()

	// Send the email
	err = smtp.SendMail(
		"smtp.gmail.com:587",
		auth,
		"weedy.challenge@gmail.com",
		[]string{to},
		[]byte(message),
	)
	if err != nil {
		return false
	}

	return true
}
