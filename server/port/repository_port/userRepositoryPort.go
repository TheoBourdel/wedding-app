package repository_port

import "api/model"

type UserRepositoryPort interface {
	FindAll() ([]model.User, error)
}
