package controller

import (
	_ "api/docs"
	"net/http"
	"api/service"
	"api/model"
	"strconv"
	"github.com/gin-gonic/gin"
	"strings"
)

type ServiceController struct {
    ServiceService service.ServiceService
    UserService service.UserService

	
}

// GetServices godoc
// @Summary Get all services
// @Description Get a list of all services
// @Tags services
// @Accept json
// @Produce json
// @Success 200 {object} []model.Service
// @Router /services [get]
func (wc *ServiceController) GetServices(ctx *gin.Context) {
    services := wc.ServiceService.FindAll()

    ctx.Header("Content-Type", "application/json")
    ctx.JSON(http.StatusOK, services)
}

// CreateService godoc
// @Summary Create a new service
// @Description Create a new service
// @Tags services
// @Accept json
// @Produce json
// @Param service body model.Service true "Service object to be created"
// @Success 201 {object} model.Service
// @Failure 400 {string} string "Invalid request"

// @Router /services [post]
func (wc *ServiceController) CreateService(ctx *gin.Context) {
    var service model.Service
    if err := ctx.ShouldBindJSON(&service); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    createdService, err := wc.ServiceService.Create(service)
    if err.Code != 0 {
        ctx.JSON(err.Code, gin.H{"message": err.Message})
        return
    }

    ctx.JSON(http.StatusCreated, createdService)
}


// GetServiceByID godoc
// @Summary Get a service by ID
// @Description Get a service by its ID
// @Tags services
// @Accept json
// @Produce json
// @Param id path int true "Service ID"
// @Success 200 {object} model.Service
// @Failure 404 {string} string "Service not found"
// @Router /services/{id} [get]
func (wc *ServiceController) GetServiceByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid service ID"})
        return
    }

    service, err := wc.ServiceService.FindByID(id)
    if err != nil { // Check if there is an error
        // Handle the error appropriately, maybe log it
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        return
    }

    ctx.JSON(http.StatusOK, service)
}

// DeleteServiceByID godoc
// @Summary Delete a service by ID
// @Description Delete a service by its ID
// @Tags services
// @Accept json
// @Produce json
// @Param id path int true "Service ID"
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid service ID"
// @Failure 404 {string} string "Service not found"
// @Failure 500 {string} string "Internal server error"
// @Router /services/{id} [delete]
func (wc *ServiceController) DeleteServiceByID(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid service ID"})
        return
    }
	
	err = wc.ServiceService.Delete(id)
    if err != nil {
        ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        return
    }

    ctx.Status(http.StatusNoContent)
}


// UpdateService godoc
// @Summary Update a service by ID
// @Description Update a service by its ID
// @Tags services
// @Accept json
// @Produce json
// @Param id path int true "Service ID"
// @Param service body model.Service true "Updated service object"
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid service ID or request body"
// @Failure 404 {string} string "Service not found"
// @Failure 500 {string} string "Internal server error"
// @Router /services/{id} [put]
func (wc *ServiceController) UpdateService(ctx *gin.Context) {
    id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
    if err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid service ID"})
        return
    }

    // Bind the updated service data from the request body
    var updatedService model.Service
    if err := ctx.ShouldBindJSON(&updatedService); err != nil {
        ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
        return
    }

    // Call the Update method from ServiceService
    updateErr := wc.ServiceService.Update(id, updatedService)
    if updateErr != nil {
        if strings.Contains(updateErr.Error(), "service not found") {
            ctx.JSON(http.StatusNotFound, gin.H{"error": updateErr.Error()})
        } else {
            ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
        }
        return
    }

    // If the update was successful, return No Content
    ctx.Status(http.StatusNoContent)
}
