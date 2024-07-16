package route

import (
	"api/controller"
	"api/port/controller_port"
	"api/middelware"

	"github.com/gin-gonic/gin"
)

func OrganizerRoutes(router *gin.Engine) {
	var OrganizerControllerPort controller_port.OrganizerControllerInterface = &controller.OrganizerController{}

	router.GET("/wedding/:id/organizers", middelware.RequireAuth,OrganizerControllerPort.GetOrganizers)
	router.DELETE("/wedding/:id/organizer/:organizerId",middelware.RequireAuth, OrganizerControllerPort.DeleteOrganizer)
}
