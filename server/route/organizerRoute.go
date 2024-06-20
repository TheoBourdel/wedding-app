package route

import (
	"api/controller"
	"api/port/controller_port"

	"github.com/gin-gonic/gin"
)

func OrganizerRoutes(router *gin.Engine) {
	var OrganizerControllerPort controller_port.OrganizerControllerInterface = &controller.OrganizerController{}

	router.GET("/wedding/:id/organizers", OrganizerControllerPort.GetOrganizers)
	router.DELETE("/wedding/:id/organizer/:organizerId", OrganizerControllerPort.DeleteOrganizer)
}
