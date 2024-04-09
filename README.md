# Lancer le backend
`docker compose up`

# Jouer les Migrations 
`docker compose exec server go run migrate/migrate.go`

# Mettre à jour le swagger
`docker compose exec server swag init --parseDependency --parseInternal`