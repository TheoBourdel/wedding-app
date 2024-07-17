package controller

import (
	_ "api/docs"
	"api/model"
	"api/service"
	"net/http"
	"strconv"
	"strings"

	"github.com/gin-gonic/gin"
)

type ImageController struct {
	ImageService service.ImageService
}

// GetImages godoc
// @Summary Get all images
// @Description Get a list of all images
// @Tags images
// @Accept json
// @Security Bearer
// @Produce json
// @Success 200 {object} []model.Image
// @Router /images [get]
func (wc *ImageController) GetImages(ctx *gin.Context) {
	images := wc.ImageService.FindAll()

	ctx.Header("Content-Type", "application/json")
	ctx.JSON(http.StatusOK, images)
}

// CreateImage godoc
// @Summary Create a new image
// @Description Create a new image
// @Tags images
// @Accept json
// @Security Bearer
// @Produce json
// @Param image body model.Image true "Image object to be created"
// @Success 201 {object} model.Image
// @Failure 400 {string} string "Invalid request"
// @Router /images [post]
func (wc *ImageController) CreateImage(ctx *gin.Context) {
	var image model.Image
	if err := ctx.ShouldBindJSON(&image); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	createdImage, err := wc.ImageService.Create(image)
	if err.Code != 0 {
		ctx.JSON(err.Code, gin.H{"message": err.Message})
		return
	}

	ctx.JSON(http.StatusCreated, createdImage)
}

// GetImageByID godoc
// @Summary Get a image by ID
// @Description Get a image by its ID
// @Tags images
// @Accept json
// @Produce json
// @Security Bearer
// @Param id path int true "Image ID"
// @Success 200 {object} model.Image
// @Failure 404 {string} string "Image not found"
// @Router /images/{id} [get]
func (wc *ImageController) GetImageByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid image ID"})
		return
	}

	image, err := wc.ImageService.FindByID(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	ctx.JSON(http.StatusOK, image)
}

// DeleteImageByID godoc
// @Summary Delete a image by ID
// @Description Delete a image by its ID
// @Tags images
// @Accept json
// @Produce json
// @Param id path int true "Image ID"
// @Security Bearer
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid image ID"
// @Failure 404 {string} string "Image not found"
// @Failure 500 {string} string "Internal server error"
// @Router /images/{id} [delete]
func (wc *ImageController) DeleteImageByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid image ID"})
		return
	}

	err = wc.ImageService.Delete(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		return
	}

	ctx.Status(http.StatusNoContent)
}

// UpdateImage godoc
// @Summary Update a image by ID
// @Description Update a image by its ID
// @Tags images
// @Accept json
// @Produce json
// @Security Bearer
// @Param id path int true "Image ID"
// @Param image body model.Image true "Updated image object"
// @Success 204 "No Content"
// @Failure 400 {string} string "Invalid image ID or request body"
// @Failure 404 {string} string "Image not found"
// @Failure 500 {string} string "Internal server error"
// @Router /images/{id} [put]
func (wc *ImageController) UpdateImage(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 64)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid image ID"})
		return
	}

	// Bind the updated image data from the request body
	var updatedImage model.Image
	if err := ctx.ShouldBindJSON(&updatedImage); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	// Call the Update method from ImageService
	updateErr := wc.ImageService.Update(id, updatedImage)
	if updateErr != nil {
		if strings.Contains(updateErr.Error(), "image not found") {
			ctx.JSON(http.StatusNotFound, gin.H{"error": updateErr.Error()})
		} else {
			ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Internal server error"})
		}
		return
	}

	// If the update was successful, return No Content
	ctx.Status(http.StatusNoContent)
}

// UploadImage godoc
// @Summary Upload an image file
// @Description Uploads an image file and saves it to the server
// @Tags images
// @Accept multipart/form-data
// @Produce json
// @Security Bearer
// @Param image formData file true "Image file"
// @Success 200 {object} map[string]interface{}
// @Failure 400 {string} string "Invalid request"
// @Failure 500 {string} string "Server error"
// @Router /images/upload [post]
func (wc *ImageController) UploadImage(c *gin.Context) {
	serviceIdStr := c.PostForm("serviceId")
	serviceId, err := strconv.ParseUint(serviceIdStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid service ID"})
		return
	}

	file, err := c.FormFile("image")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "No file received"})
		return
	}

	path := "uploads/" + file.Filename
	if err := c.SaveUploadedFile(file, path); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save the file"})
		return
	}

	image := model.Image{Path: path, ServiceID: uint(serviceId)}
	savedImage, errDto := wc.ImageService.Create(image)
	if errDto.Code != 0 {
		c.JSON(errDto.Code, gin.H{"error": errDto.Message})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "File uploaded successfully", "path": savedImage.Path})
}
