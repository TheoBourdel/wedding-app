# Lancer le backend
`docker compose up`

# Jouer les Migrations 
`docker compose exec server go run migrate/migrate.go`

# Installer les libraries que vous avez importé
`docker compose exec server go mod tidy`

# Mettre à jour le swagger
`docker compose exec server swag init --parseDependency --parseInternal`