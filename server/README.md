# Lancer le backend
`docker compose up`

# Jouer les Migrations 
`docker compose exec server go run migrate/migrate.go`

# Installer les libraries que vous avez importé
`docker compose exec server go mod tidy`

# Installer swag
`docker compose exec server go install github.com/swaggo/swag/cmd swag@latest`

# Mettre à jour le swagger
`docker compose exec server swag init --parseDependency --parseInternal`
 