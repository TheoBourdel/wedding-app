package controller_port

import "github.com/gin-gonic/gin"

type UserControllerInterface interface {
	GetUsers(c *gin.Context)
	CreateUser(c *gin.Context)
	GetUser(c *gin.Context)
<<<<<<< HEAD
	CreateUserEstimate(c *gin.Context)
	GetUserEstimates(c *gin.Context)
=======
	UpdateUserFirebaseToken(c *gin.Context)
>>>>>>> d0c5837 (ajouter la fonction pour recuperer le token du user)
}
