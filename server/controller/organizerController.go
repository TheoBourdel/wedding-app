package controller

import (
	_ "api/docs"
	"api/dto"
	"api/service"

	"github.com/gin-gonic/gin"
)

type OrganizerController struct {
	OrganizerService service.OrganizerService
}

func (controller *OrganizerController) GetOrganizers(ctx *gin.Context) {
	weddingId := ctx.Param("id")

	organizers, err := controller.OrganizerService.GetOrganizers(weddingId)
	if err != (dto.HttpErrorDto{}) {
		ctx.JSON(err.Code, gin.H{"message": err.Message})
		return
	}

	ctx.JSON(200, organizers)
}

func (controller *OrganizerController) DeleteOrganizer(ctx *gin.Context) {
	weddingId := ctx.Param("id")
	organizerId := ctx.Param("organizerId")

	err := controller.OrganizerService.DeleteOrganizer(weddingId, organizerId)
	if err != (dto.HttpErrorDto{}) {
		ctx.JSON(err.Code, gin.H{"message": err.Message})
		return
	}

	ctx.JSON(204, nil)
}
